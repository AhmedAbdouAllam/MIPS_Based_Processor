#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <algorithm>
#include <sstream>
#include <map>
#include <bitset>

using namespace std;

struct Instruction {
	string func;
	vector<string> OPS;
	bool invalid;
};
std::map<std::string, std::string> functionMap;
std::vector<std::string> initializingInstructions;

string replace(string str, string toReplace, string replacement);
void initializeMap();
void initializeInstructions();
vector<Instruction> readFile(string fname);
Instruction parseLine(string line);
vector<string> splitOnce(string str, char delimiter);
string removeWhiteSpace(string str);
vector<string> split(string str, char delimeter);
string getOPCode(Instruction is);
int stringToInt(string);

int main()
{
	initializeMap();
	initializeInstructions();

	//get I/P & O/P filenames
	string inFileName, outFileName;
	cout << "Example: ./program.txt\nThe \"./\" can be omitted if the the file is in the same working directory.\n";
	cout << "Instructions path (relative): ";
	cin >> inFileName;
	cout << ".mem file path (relative): ";
	cin >> outFileName;

	vector<Instruction> instructions = readFile(inFileName);
	for (int i = 0; i < instructions.size(); i++) {
		cout << instructions[i].func << " ";
		for (int j = 0; j < instructions[i].OPS.size(); j++) {
			cout << instructions[i].OPS[j];
			if (j + 1 != instructions[i].OPS.size()) {
				cout << ",";
			}
		}
		cout << "\n";
	}
	cout << "==========================\n";
	ofstream programFile;
	programFile.open(outFileName);
	for (int i = 0; i < initializingInstructions.size(); i++) {
		programFile << initializingInstructions[i] << "\n";
	}
	int counter = 0;
	for (int i = 0; i < instructions.size(); i++) {
		string opcode = getOPCode(instructions[i]);
		if (opcode == "ORG") {
			counter = stringToInt(instructions[i].OPS[0]);
			continue;
		}
		programFile << counter++ << ": ";
		if (opcode.find("\n") != string::npos) {
			string lineIndex = "\n";
			lineIndex.append(to_string(counter++));
			lineIndex.append(": ");
			opcode = replace(opcode, "\n", lineIndex);
		}
		programFile << opcode;
		if (i + 1 != instructions.size()) {
			programFile << "\n";
		}
	}
	programFile.close();
	return 0;
}


vector<Instruction> readFile(string fname) {
	ifstream file;
	file.open(fname);
	if (!file) {
		cout << "Couldn't Open File: " << fname;
		exit(1);
	}
	vector<Instruction> instructions;
	string line;
	while (getline(file, line)) {
		Instruction is = parseLine(line);
		if (is.invalid) continue;
		instructions.push_back(parseLine(line));
	}
	file.close();
	return instructions;
};

Instruction parseLine(string line) {

	Instruction is;
	//Remove comments..
	line = line.substr(0, line.find(';'));
	if (!line.length()) {
		is.invalid = true;
		cout << "invalid length\n";
		return is;
	}

	vector<string> func_op = splitOnce(line, ' ');

	is.func = func_op[0];
	if (func_op.size() > 1) {
		vector<string> x = split(func_op[1], ',');
		if (x.size() > 1 && removeWhiteSpace(x[1]).size() > 0) {
			is.OPS = split(func_op[1], ',');
		}
		else {
			is.OPS = { split(func_op[1], ',')[0] };
		}

	}
	is.invalid = false;
	return is;
}

vector<string> splitOnce(string str, char delimiter) {
	vector<string> tokens;
	int prevIndex = 0;
	int currIndex = 0;
	bool did = false;
	while (currIndex < str.length()) {
		if (str[currIndex] == delimiter && !did) {
			string token = removeWhiteSpace(str.substr(prevIndex, currIndex));
			token.erase(remove(token.begin(), token.end(), delimiter), token.end());
			tokens.push_back(token);
			prevIndex = currIndex;
			did = true;
		}
		currIndex++;
	}
	string token = removeWhiteSpace(str.substr(prevIndex, currIndex));
	token.erase(remove(token.begin(), token.end(), delimiter), token.end());

	tokens.push_back(token);
	return tokens;
}

vector<string> split(string str, char delimiter) {
	vector<string> tokens;
	int prevIndex = 0;
	int currIndex = 0;
	while (currIndex < str.length()) {
		if (str[currIndex] == delimiter) {
			string token = removeWhiteSpace(str.substr(prevIndex, currIndex));
			token.erase(remove(token.begin(), token.end(), delimiter), token.end());
			tokens.push_back(token);
			prevIndex = currIndex;
		}
		currIndex++;
	}
	string token = removeWhiteSpace(str.substr(prevIndex, currIndex));
	token.erase(remove(token.begin(), token.end(), delimiter), token.end());

	tokens.push_back(token);
	return tokens;

}

string removeWhiteSpace(string str) {
	string str2 = "";
	for (int i = 0; i < str.length(); i++) {
		if (str[i] != ' ') {
			str2.append(1, str[i]);
		}
	}
	return str2;
}

string toUpperCase(string str) {
	for (int i = 0; i < str.length(); i++) {
		str[i] = toupper(str[i]);
	}
	return str;
}

string replace(string str, string toReplace, string replacement) {
	str.replace(str.find(toReplace), toReplace.length(), replacement);

	return str;
}

string numberCharToBinary(char c) {
	int _i = c - '0';

	return bitset<3>(_i).to_string();
}

int stringToInt(string str) {
	stringstream stream(str);
	int _i;
	stream >> _i;
	return _i;
}

string decimalToBinary(string dec, int bitNum) {
	stringstream stream(dec);
	int _i;
	stream >> _i;
	if (bitNum == 16) return bitset<16>(_i).to_string();
	else if (bitNum == 5) return bitset<5>(_i).to_string();
	else if (bitNum == 32) return bitset<32>(_i).to_string();
	return bitset<20>(_i).to_string();
}

string RegToBinary(string Reg) {
	string regNum = replace(toUpperCase(Reg), "R", "");

	return numberCharToBinary(regNum[0]);
}
void checkValidity(string func, int validSize, int size) {
	if (size != validSize) {
		cout << "Error: " << func << " instruction should have no operands. found: " << size;
		exit(1);
	}
}

bool isNumber(string str) {
	char numbers[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
	for (int i = 0; i < str.size(); i++) {
		bool found = false;
		for (int j = 0; j < 10; j++) {
			if (numbers[j] == str[i]) {
				found = true;
				break;
			}
		}
		if (!found) return false;
	}
	return true;
}

string getOPCode(Instruction is) {
	if (isNumber(is.func)) {
		string op = decimalToBinary(is.func, 32);
		return op.substr(16, 16) + "\n" + op.substr(0, 16);
	}
	string func = toUpperCase(is.func);

	if (func == ".ORG") {
		checkValidity(func, 1, is.OPS.size());
		return "ORG";//This is a signal for the generator not an actual opCode
	}
	else if (func == "NOT"
		|| func == "INC"
		|| func == "DEC"
		|| func == "OUT"
		|| func == "IN") {
		checkValidity(func, 1, is.OPS.size());
		string toReplace = func == "OUT" ? "Rsrc" : "Rdst";
		return replace(functionMap[func], toReplace, RegToBinary(is.OPS[0]));
	}
	else if (func == "RET" || func == "RTI" ||
		func == "NOP" || func == "SETC" || func == "CLRC") {
		checkValidity(func, 0, is.OPS.size());
		return functionMap[func];
	}
	else if (func == "SWAP") {
		checkValidity(func, 2, is.OPS.size());
		string s = replace(functionMap[func], "Rdst", RegToBinary(is.OPS[0]));
		s = replace(s, "Rsrc", RegToBinary(is.OPS[1]));
		return s;
	}
	else if (func == "ADD" ||
		func == "SUB" ||
		func == "AND" ||
		func == "OR") {
		checkValidity(func, 3, is.OPS.size());
		string s = replace(functionMap[func], "Rdst", RegToBinary(is.OPS[0]));
		s = replace(s, "Rsrc", RegToBinary(is.OPS[1]));
		s = replace(s, "Rsrc", RegToBinary(is.OPS[2]));
		return s;
	}
	else if (func == "POP" || func == "PUSH") {
		checkValidity(func, 1, is.OPS.size());
		string toReplace = func == "POP" ? "Rdst" : "Rsrc";
		return replace(functionMap[func], toReplace, RegToBinary(is.OPS[0]));
	}
	else if (func == "JZ" || func == "JN" ||
		func == "JC" || func == "JMP") {
		checkValidity(func, 1, is.OPS.size());
		return replace(functionMap[func], "Rdst", RegToBinary(is.OPS[0]));
	}
	else if (func == "CALL") {
		checkValidity(func, 1, is.OPS.size());
		return replace(functionMap[func], "Rsrc", RegToBinary(is.OPS[0]));
	}
	else if (func == "LDD" || func == "STD") {
		checkValidity(func, 2, is.OPS.size());
		string EA = decimalToBinary(is.OPS[1], 20);
		string EA1 = "00";
		EA1.append(EA.substr(0, 4));
		string EA2 = EA.substr(4, EA.length());
		string toReplace = func == "LDD" ? "Rdst" : "Rsrc";
		string s = replace(functionMap[func], toReplace, RegToBinary(is.OPS[0]));
		s = replace(s, "EA1", EA1);
		s = replace(s, "EA2", EA2);
		return s;
	}
	else if (func == "IADD") {
		checkValidity(func, 3, is.OPS.size());
		string s = replace(functionMap[func], "Rdst", RegToBinary(is.OPS[0]));
		s = replace(s, "Rsrc", RegToBinary(is.OPS[1]));
		string IMM = decimalToBinary(is.OPS[2], 16);
		s = replace(s, "IMM", IMM);
		return s;
	}
	else if (func == "LDM") {
		checkValidity(func, 2, is.OPS.size());
		string s = replace(functionMap[func], "Rdst", RegToBinary(is.OPS[0]));
		string IMM = decimalToBinary(is.OPS[1], 16);
		s = replace(s, "IMM", IMM);
		return s;
	}
	else if (func == "SHL" || func == "SHR") {
		checkValidity(func, 2, is.OPS.size());
		string s = replace(functionMap[func], "Rsrc", RegToBinary(is.OPS[0]));
		string IMM = decimalToBinary(is.OPS[1], 5);
		string IMM_S = "0";
		IMM_S.append(IMM);
		s = replace(s, "IMM_S", IMM_S);
		return s;
	}
	return "";
}

void initializeMap() {
	functionMap["NOP"] = "0000000000000000";
	functionMap["SETC"] = "0000101000000000";
	functionMap["CLRC"] = "0000100000000000";
	functionMap["NOT"] = "0010100Rdst000000";
	functionMap["INC"] = "0011000Rdst000000";
	functionMap["DEC"] = "0011001Rdst000000";
	functionMap["OUT"] = "0010110Rsrc000000";
	functionMap["IN"] = "0010111000000Rdst";
	functionMap["SWAP"] = "0100110Rdst000Rsrc";
	functionMap["ADD"] = "0100000RsrcRsrcRdst";
	functionMap["SUB"] = "0100001RsrcRsrcRdst";
	functionMap["AND"] = "0100010RsrcRsrcRdst";
	functionMap["OR"] = "0100011RsrcRsrcRdst";
	functionMap["IADD"] = "1100000Rsrc000Rdst\nIMM";
	functionMap["SHL"] = "0101000RsrcIMM_S";
	functionMap["SHR"] = "0101001RsrcIMM_S";
	functionMap["LDM"] = "1100001000000Rdst\nIMM";
	functionMap["POP"] = "0110000000000Rdst";
	functionMap["PUSH"] = "0110001Rsrc000000";
	functionMap["LDD"] = "1110000EA1Rdst\nEA2";
	functionMap["STD"] = "1110001RsrcEA1\nEA2";
	functionMap["JZ"] = "0111100Rdst000000";
	functionMap["JN"] = "0111101Rdst000000";
	functionMap["JC"] = "0111110Rdst000000";
	functionMap["JMP"] = "0111111Rdst000000";
	functionMap["CALL"] = "1110100Rsrc000000";
	functionMap["RET"] = "1110110000000000";
	functionMap["RTI"] = "1110111000000000";
}

void initializeInstructions() {

	initializingInstructions.push_back("// memory data file (do not edit the following line - required for mem load use)");
	initializingInstructions.push_back("// instance=/aprocessor/IFetch/InstrMem/ram");
	initializingInstructions.push_back("// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1");
}