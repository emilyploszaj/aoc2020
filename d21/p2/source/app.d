import std.algorithm;
import std.array;
import std.file;
import std.stdio;
import std.string;

string[][string] possibles;

string[] allIngredients;
int[string] appearances;

void main() {
	string input = cast(string) read("../input.txt");
	string[] lines = input.split("\n")[0..$ - 1];
	foreach (string line; lines) {
		string[] parts = line.split(" (");
		string[] ingredients = parts[0].split(' ');
		string[] alergens = parts[1][9..$ - 1].split(", ");
		foreach (string alergen; alergens) {
			if (alergen in possibles) {
				possibles[alergen] = possibles[alergen].filter!(a => ingredients.canFind(a)).array;
			} else {
				possibles[alergen] = ingredients.dup;
			}
		}
		foreach (string ingredient; ingredients) {
			if (!allIngredients.canFind(ingredient)) {
				allIngredients ~= ingredient;
			}
			appearances[ingredient]++;
		}
	}
	int total;
	foreach (string key, int value; appearances) {
		if (!possibles.byValue.canFind!((string[] p, k) => p.canFind(k))(key)) {
			total += value;
		}
	}
	string[][] finalAlergens;
	while (possibles.length > 0) {
		foreach (string key, string[] value; possibles) {
			if (value.length == 1) {
				finalAlergens ~= [key, value[0]];
				foreach (string k, string[] v; possibles) {
					v = v.filter!(a => a != value[0]).array;
					if (v.length > 0) {
						possibles[k] = v;
					} else {
						possibles.remove(k);
					}
				}
				break;
			} 
		}
	}
	finalAlergens
		.sort!((a, b) => cmp(a[0], b[0]) < 0)
		.map!(a => a[1])
		.join(',')
		.writeln;
}
