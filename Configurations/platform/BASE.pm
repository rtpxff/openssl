package platform::BASE;

use strict;
use warnings;
use Carp;

#rtpxff:
my $vcx_proj;

# Assume someone set @INC right before loading this module
use configdata;

# Globally defined "platform specific" extensions, available for uniformity
sub depext      { '.d' }

# Functions to convert internal file representations to platform specific
# ones.  Note that these all depend on extension functions that MUST be
# defined per platform.
#
# Currently known internal or semi-internal extensions are:
#
# .a            For libraries that are made static only.
#               Internal libraries only.
# .o            For object files.
# .s, .S        Assembler files.  This is an actual extension on Unix
# .res          Resource file.  This is an actual extension on Windows

sub binname     { return $_[1] } # Name of executable binary
sub dsoname     { return $_[1] } # Name of dynamic shared object (DSO)
sub sharedname  { return __isshared($_[1]) ? $_[1] : undef } # Name of shared lib
sub staticname  { return __base($_[1], '.a') } # Name of static lib

# Convenience function to convert the shlib version to an acceptable part
# of a file or directory name.  By default, we consider it acceptable as is.
sub shlib_version_as_filename { return $config{shlib_version} }

# Convenience functions to convert the possible extension of an input file name
sub bin         { return $_[0]->binname($_[1]) . $_[0]->binext() }
sub dso         { return $_[0]->dsoname($_[1]) . $_[0]->dsoext() }
sub sharedlib   { return __concat($_[0]->sharedname($_[1]), $_[0]->shlibext()) }
sub staticlib   { return $_[0]->staticname($_[1]) . $_[0]->libext() }

#rtpxff: 
sub vcx_bin_open {
    my $lib_file = $_[0]->binname($_[1]) . $_[0]->vcxprojext();
    open $vcx_proj, ">>", $lib_file or die "can't open $lib_file\n";
    vcx_print_init ($_[0]->binname($_[1]));
}

#rtpxff: 
sub vcx_dll_open {
    my $lib_file = $_[0]->binname($_[1]) . $_[0]->vcxprojext();
    open $vcx_proj, ">>", $lib_file or die "can't open $lib_file\n";
    vcx_print_init ($_[0]->binname($_[1]));
}

#rtpxff: 
sub vcx_static_open {
    my $lib_file = $_[0]->staticname($_[1]) . $_[0]->vcxprojext();
    open $vcx_proj, ">>", $lib_file or die "can't open $lib_file\n";
    vcx_print_init ($_[0]->staticname($_[1]));
}

#rtpxff: 
sub vcx_print {
    if (length $vcx_proj) {
        print $vcx_proj $_[1];
    }
}

#rtpxff: 
sub vcx_print_init {
    my $proj_name = $_[1];
    print $vcx_proj "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<Project DefaultTargets=\"Build\" xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">
  <ItemGroup Label=\"ProjectConfigurations\">
    <ProjectConfiguration Include=\"Debug|x64\">
      <Configuration>Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include=\"Release|x64\">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>
  <Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x64'\" Label=\"Configuration\">
    <ConfigurationType>DynamicLibrary</ConfigurationType>
    <UseDebugLibraries>true</UseDebugLibraries>
    <PlatformToolset>v143</PlatformToolset>
  </PropertyGroup>
  <PropertyGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x64'\" Label=\"Configuration\">
    <ConfigurationType>DynamicLibrary</ConfigurationType>
    <UseDebugLibraries>false</UseDebugLibraries>
    <PlatformToolset>v143</PlatformToolset>
    <WholeProgramOptimization>true</WholeProgramOptimization>
  </PropertyGroup>
  <Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />
  <ImportGroup Label=\"ExtensionSettings\">
  </ImportGroup>
  <ImportGroup Label=\"Shared\">
  </ImportGroup>
  <ImportGroup Label=\"PropertySheets\" Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x64'\">
    <Import Project=\"\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props\" Condition=\"exists('\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props')\" Label=\"LocalAppDataPlatform\" />
  </ImportGroup>
  <ImportGroup Label=\"PropertySheets\" Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x64'\">
    <Import Project=\"\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props\" Condition=\"exists('\$(UserRootDir)\\Microsoft.Cpp.\$(Platform).user.props')\" Label=\"LocalAppDataPlatform\" />
  </ImportGroup>
  <PropertyGroup Label=\"UserMacros\" />
  <PropertyGroup />
  <ItemDefinitionGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Debug|x64'\">
    <ClCompile>
      <PreprocessorDefinitions>_DEBUG;%(PreprocessorDefinitions)</PreprocessorDefinitions>
    </ClCompile>
    <ResourceCompile>
      <PreprocessorDefinitions>proj_name</PreprocessorDefinitions>
    </ResourceCompile>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition=\"'\$(Configuration)|\$(Platform)'=='Release|x64'\">
    <ClCompile>
      <PreprocessorDefinitions>NDEBUG;%(PreprocessorDefinitions)</PreprocessorDefinitions>
    </ClCompile>
    <ResourceCompile>
      <PreprocessorDefinitions>proj_name</PreprocessorDefinitions>
    </ResourceCompile>
  </ItemDefinitionGroup>";
}

#rtpxff: 
sub vcx_finish {
    print $vcx_proj "
  <Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />
  <ImportGroup Label=\"ExtensionTargets\">
  </ImportGroup>
  <Target Name=\"AfterClean\">
  </Target>
</Project>\n";
}

# More convenience functions for intermediary files
sub def         { return __base($_[1], '.ld') . $_[0]->defext() }
sub obj         { return __base($_[1], '.o') . $_[0]->objext() }
sub res         { return __base($_[1], '.res') . $_[0]->resext() }
sub dep         { return __base($_[1], '.o') . $_[0]->depext() } # <- objname
sub asm         { return __base($_[1], '.s') . $_[0]->asmext() }

# Another set of convenience functions for standard checks of certain
# internal extensions and conversion from internal to platform specific
# extension.  Note that the latter doesn't deal with libraries because
# of ambivalence
sub isdef       { return $_[1] =~ m|\.ld$|;   }
sub isobj       { return $_[1] =~ m|\.o$|;    }
sub isres       { return $_[1] =~ m|\.res$|;  }
sub isasm       { return $_[1] =~ m|\.s$|;    }
sub iscppasm    { return $_[1] =~ m|\.S$|;    }
sub isstaticlib { return $_[1] =~ m|\.a$|;    }
sub convertext {
    if ($_[0]->isdef($_[1]))        { return $_[0]->def($_[1]); }
    if ($_[0]->isobj($_[1]))        { return $_[0]->obj($_[1]); }
    if ($_[0]->isres($_[1]))        { return $_[0]->res($_[1]); }
    if ($_[0]->isasm($_[1]))        { return $_[0]->asm($_[1]); }
    if ($_[0]->isstaticlib($_[1]))  { return $_[0]->staticlib($_[1]); }
    return $_[1];
}

# Helpers ############################################################

# __base EXPR, LIST
# This returns the given path (EXPR) with the matching suffix from LIST stripped
sub __base {
    my $path = shift;
    foreach (@_) {
        if ($path =~ m|\Q${_}\E$|) {
            return $`;
        }
    }
    return $path;
}

# __isshared EXPR
# EXPR is supposed to be a library name.  This will return true if that library
# can be assumed to be a shared library, otherwise false
sub __isshared {
    return !($disabled{shared} || $_[0] =~ /\.a$/);
}

# __concat LIST
# Returns the concatenation of all elements of LIST if none of them is
# undefined.  If one of them is undefined, returns undef instead.
sub __concat {
    my $result = '';
    foreach (@_) {
        return undef unless defined $_;
        $result .= $_;
    }
    return $result;
}

1;
