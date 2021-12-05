<?php

declare(strict_types = 1);
/**
 * バイナリから MZT ファイルを生成します / Generates an MZT file from a binary
 * 
 * 使い方は, Usage: 行を参照してください / For usage, see the "Usage:" line
 *
 * MZT ファイル フォーマット / MZT File Format 
 * 0x00     : ファイル モード (0x01 = バイナリ)
 *            File mode (0x01 = binary)
 * 0x01-0x11: ファイル名. 大文字のみ. スペースOK. 0x0d 末端. 残りは 0x0d でパディング
 *            File name. Capital letters only. Space OK. 0x0d end. The rest is padded with 0x0d
 * 0x12-0x13: バイナリのサイズ
 *            Size of the binary
 * 0x14-0x15: ロード アドレス
 *            Load address
 * 0x16-0x17: 実行開始アドレス
 *            Execution start address
 * 0x18-0x7f: とりあえず 0x00 で埋める
 *            Fill it with 0x00 for now
 *
 * @author Snail Barbarian Macho (NWK) 2021.07.06
 */

// --------------------------------

// 引数チェック / Argument check
if (count($argv) !== 6)
{
    fwrite(STDERR, 'Usage: php '.$argv[0]." <binary file> <program name> <load address> <exec address> outfile.mzt\n");
    fwrite(STDERR, "  Program name converted in upper case, up to 16 characters.\n");
    fwrite(STDERR, "  Both addresses can be decimal or hexadecimal(0x).\n");
    exit(1);
}
$binFilename = $argv[1];
$progName    = $argv[2];
$loadAddr    = $argv[3];
$execAddr    = $argv[4];
$outMzt      = $argv[5];

// ファイル存在チェック / File existence check
if (file_exists($binFilename) === false)
{
    fwrite(STDERR, "File not found[$binFilename]\n");
    exit(1);
}

// プログラム名. 小文字は大文字に, 16文字に揃えて末端に 0x0d で埋めて 17 バイトにします
// Program name. Lower case letters are capitalized, aligned to 16 characters and terminated with 0x0d to make 17 bytes
$progName = substr(strtoupper($progName), 0, 16);
for ($i = strlen($progName); $i < 17; $i++) {
    $progName .= pack("C", 0x0d);
}

// ロード, 実行アドレス. '0x' で始まるなら 16 進数 / Load, execution address. Hexadecimal if it starts with '0x'.
$loadAddr = strtolower($loadAddr);
$execAddr = strtolower($execAddr);
if (str_starts_with($loadAddr, '0x')) {
    $loadAddr = hexdec(substr($loadAddr, 2));
}
if (str_starts_with($execAddr, '0x')) {
    $execAddr = hexdec(substr($execAddr, 2));
}

// ファイル ロード / File Load
$binData = file_get_contents($binFilename);
if (!$binData) {
    fwrite(STDERR, "File open error [$binFilename]\n");
    exit(1);
}
$binSize =  strlen($binData);

printf("==== [%s] Binary size: 0x%04x Load addr: 0x%04x Exec addr: 0x%04x ====\n", $outMzt, $binSize, $loadAddr, $execAddr);


$data = pack("C", 0x01);        // ファイル モード / File type
$data .= $progName;             // プログラム名 / Program name
$data .= pack("v", $binSize);   // バイナリ サイズ / Binary size
$data .= pack("v", $loadAddr);  // ロード アドレス / Load address
$data .= pack("v", $execAddr);  // 実行開始アドレス / Execution start address
for ($i = 0; $i < 0x68; $i++)
{
    $data .= pack("C", 0x00);  // ファイルコメント / File comment
}
$data .=  $binData;

file_put_contents($outMzt, $data);
