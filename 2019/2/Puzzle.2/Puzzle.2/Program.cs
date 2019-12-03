using System;
using System.IO;

namespace Puzzle._2
{
    class Program
    {
        static void Main(string[] args)
        {
            var lineInput = File.ReadAllText("input.txt");

            var inputs =  Array.ConvertAll(lineInput.Split(','), x => Convert.ToInt32(x));

            inputs[1] = 12;
            inputs[2] = 2;

            var @continue = true;
            int noun = -1;
            int verb = -1;

            for (int x = 0; x < inputs.Length; x += 4)
            {
                if (@continue)
                {
                    switch (inputs[x])
                    {
                        case 1:
                            inputs[inputs[x + 3]] = inputs[inputs[x + 1]] + inputs[inputs[x + 2]];
                            break;
                        case 2:
                            inputs[inputs[x + 3]] = inputs[inputs[x + 1]] * inputs[inputs[x + 2]];
                            break;
                        case 99:
                            @continue = false;
                            break;
                    }
                }
            }

            Console.WriteLine($"{inputs[0]}");

            for (int i = 0; i < 99 && noun == -1; ++i)
            {
                for(int j = 0; j < 99 && noun == -1; ++j)
                {
                    inputs = Array.ConvertAll(lineInput.Split(','), x => Convert.ToInt32(x));
                    inputs[1] = i;
                    inputs[2] = j;
                    @continue = true;

                    for (int x = 0; x < inputs.Length; x += 4)
                    {
                        if (@continue)
                        {
                            switch (inputs[x])
                            {
                                case 1:
                                    inputs[inputs[x + 3]] = inputs[inputs[x + 1]] + inputs[inputs[x + 2]];
                                    break;
                                case 2:
                                    inputs[inputs[x + 3]] = inputs[inputs[x + 1]] * inputs[inputs[x + 2]];
                                    break;
                                case 99:
                                    @continue = false;
                                    break;
                            }
                        }
                    }

                    if(inputs[0] == 19690720)
                    {
                        noun = i;
                        verb = j;
                    }
                }
            }

            Console.WriteLine($"{100 * noun + verb}");
        }
    }
}
