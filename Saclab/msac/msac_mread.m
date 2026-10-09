%MSAC_MREAD - Read multiple SAC time series files and return an array of
%             structures containing them.
%
%  [sac_trace_structure] = msac_mread(wildcard) ;
%
%  This reads multiple SAC files, specified by the wilcard. This
%  is expanded by the using the MATLAB ls command. 
%
%  [sac_trace_structure,namelist] =  msac_mread(wildcard) ;
%
%  This syntax also returns the list of filenames which matched the wildcard;
%  this is useful for writing the set of files out again after processing.
%

%-------------------------------------------------------------------------------
%
%  This software is distributed under the term of the BSD free software license.
%
%  Copyright:
%     (c) 2003-2008, James Wookey
%
%  All rights reserved.
%
%   * Redistribution and use in source and binary forms, with or without
%     modification, are permitted provided that the following conditions are
%     met:
%        
%   * Redistributions of source code must retain the above copyright notice,
%     this list of conditions and the following disclaimer.
%        
%   * Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%     
%   * Neither the name of the copyright holder nor the names of its
%     contributors may be used to endorse or promote products derived from
%     this software without specific prior written permission.
%
%
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
%   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%-------------------------------------------------------------------------------

function [varargout] = msac_mread(wildcard) ;

[s,raw] = system(['ls ',wildcard,' | cat ']) ;
filenames = strread(raw,'%q') ;
 
[nfiles ndum] = size(filenames) ;

for ifile=1:nfiles
%  read each file using msac_read
   fname = char(filenames(ifile)) ;
   traces(ifile) = msac_read(fname) ;
end

if (nargout==2)
   varargout = {traces,filenames} ;
elseif (nargout==1)
   varargout = {traces} ;
else
   error('Not enough outputs specified for MSAC_MREAD') ;
end

return
% end of MSAC_MREAD.M

