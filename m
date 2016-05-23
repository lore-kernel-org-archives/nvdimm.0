Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 23DC31A1DE8
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 11:00:01 -0700 (PDT)
Date: Mon, 23 May 2016 11:59:15 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: add bash completion
Message-ID: <20160523175915.GA17835@omniknight.lm.intel.com>
References: <1463791855-24615-1-git-send-email-vishal.l.verma@intel.com>
 <1463791855-24615-3-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4g-bAf+crkeaCo3-d6w1av7i=WFefo2fuRPJcCDnfvShA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g-bAf+crkeaCo3-d6w1av7i=WFefo2fuRPJcCDnfvShA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 23, 2016 at 07:36:25AM -0700, Dan Williams wrote:
> On Fri, May 20, 2016 at 5:50 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > Add bash completion support to ndctl and integrate it with autotools.
> > The completion is based on perf/git, and the usage experience is very
> > similar.
> >
> > We do dynamic generation of options using --list-opts for the different
> > subcommands. We also attempt to complete long-options that take an
> > additional parameter (such as --region=region0), and non-option
> > arguments, such as the namespace for a 'disable-namespace' command.
> >
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> [..]
> > +
> > +__ndctlcomp()
> > +{
> > +       local i=0
> > +
> > +       COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
> > +       for cword in "${COMPREPLY[@]}"; do
> > +               if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|
> > +                       --reconfig|--uuid|--name|--sector-size|--map) ]]; then
> 
> I believe that this statement is including the whitespace before the
> --reconfig since the completion is not appending the '=' when
> completing --reconfig.  Maybe we should modify --list-opts to append
> the '=' automatically?

You're right, that was causing the '=' to be missed, but I had also
neglected to add the namespace completion to refconfig in
__ndctl_comp_options. Fixing that. For now, I'm just removing the line
break in the 'if' to fix the '=', but yes, if --list-opts could be
=-aware, that would keep us from having this list :)

Another extra-credit: for options without an '=', append a <space> like
git does --> done.
> 
> Extra credit would be to have the --reconfig completion suggest namespaces.

Done

> 
> Extra-extra credit would be to have the suggested namespaces filtered
> by bus and region.

I thought about this, but left it out for v1 thinking it might make
completion overly smart.. but I suppose that's a good thing :) - I'll
see what I can come up with...
> 
> 
> > +                       COMPREPLY[$i]="${cword}="
> > +               fi
> > +               ((i++))
> > +       done
> > +}
> > +
> > +__ndctl_get_buses()
> > +{
> > +       echo "$(ndctl list --buses | grep -E "^\s*\"provider\":" | cut -d\" -f4)"
> > +}
> > +
> > +__ndctl_get_regions()
> > +{
> > +       echo "$(ndctl list --regions | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
> > +}
> > +
> > +__ndctl_get_ns()
> > +{
> > +       echo "$(ndctl list --namespaces | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
> > +}
> 
> Hmm, for the above 2 we might want to optionally specify "-i" to
> include idle / disabled namespaces and regions, especially for the
> enable-{region|namespace} case.

Good point I didn't know of -i - I'll add it.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
