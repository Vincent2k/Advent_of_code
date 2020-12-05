using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Puzzle.Core.Interfaces
{
    public interface IApplicationEntrypoint
    {
        void EnterInitialization(IServiceCollection serviceCollection);

        Task EnterApplicationStart(IServiceProvider serviceProvider); 
    }
}
