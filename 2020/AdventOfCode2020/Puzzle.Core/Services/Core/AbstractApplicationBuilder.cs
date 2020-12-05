using Microsoft.Extensions.DependencyInjection;
using Puzzle.Core.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Puzzle.Core.Services.Core
{
    public abstract class AbstractApplicationBuilder
    {
        private IApplicationEntrypoint _applicationEntrypoint;
        private readonly IServiceCollection _serviceCollection;

        public AbstractApplicationBuilder()
        {
            _serviceCollection = new ServiceCollection();
        }

        public static AbstractApplicationBuilder CreateApplicationBuilder()
        {
            var applicationBuilder = new DefaultApplicationBuilder();
            return applicationBuilder;
        }

        public void UseEntrypoint<TEntrypoint>() where TEntrypoint : class, IApplicationEntrypoint
        {
            _applicationEntrypoint = (TEntrypoint)Activator.CreateInstance(typeof(TEntrypoint));

            _applicationEntrypoint.EnterInitialization(_serviceCollection);
        }
    }
}
