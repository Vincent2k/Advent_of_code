using Microsoft.Extensions.DependencyInjection;
using Puzzle.Core.Interfaces;
using Puzzle.Core.Services.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Puzzle.Core
{
    public class ApplicationRunner
    {
        private readonly IServiceProvider _rootServiceProvider;

        public ApplicationRunner(IServiceProvider serviceProvider)
        {
            _rootServiceProvider = serviceProvider;
        }

        public void Run()
        {
            var applicationEntrypoint = _rootServiceProvider.GetService<IApplicationEntrypoint>();

            using var scope = _rootServiceProvider.CreateScope();

            applicationEntrypoint.EnterApplicationStart(scope.ServiceProvider).Wait();
        }
    }
}
