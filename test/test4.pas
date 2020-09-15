1       {int}                                   {int}
1.      {unknown}                               {int, period}
0.      {unknown}                               {int, period}
0.1     {real}                                  {real}
.1      {period, int}                           {period, int}
1E-2    {real}                                  {real}
1.0E-2  {real}                                  {real}
1.E-2   {unknown, identifier, minus, int}       {int, period, identifier, minus, int}
1.0E1.0 {real, period, int}                     {real, period, int}
1E      {unknown}                               {int, identifier}
2E.1    {unknown, period, int}                  {int, identifier, period, int}
1..2    {int, subrange, int}                    {int, subrange, int}