Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B54941A1E9B
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 07:36:35 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id k23so73530301oih.0
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 07:36:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463791855-24615-3-git-send-email-vishal.l.verma@intel.com>
References: <1463791855-24615-1-git-send-email-vishal.l.verma@intel.com>
 <1463791855-24615-3-git-send-email-vishal.l.verma@intel.com>
Date: Mon, 23 May 2016 07:36:25 -0700
Message-ID: <CAPcyv4g-bAf+crkeaCo3-d6w1av7i=WFefo2fuRPJcCDnfvShA@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: add bash completion
From: Dan Williams <dan.j.williams@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 20, 2016 at 5:50 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add bash completion support to ndctl and integrate it with autotools.
> The completion is based on perf/git, and the usage experience is very
> similar.
>
> We do dynamic generation of options using --list-opts for the different
> subcommands. We also attempt to complete long-options that take an
> additional parameter (such as --region=region0), and non-option
> arguments, such as the namespace for a 'disable-namespace' command.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> +
> +__ndctlcomp()
> +{
> +       local i=0
> +
> +       COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
> +       for cword in "${COMPREPLY[@]}"; do
> +               if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|
> +                       --reconfig|--uuid|--name|--sector-size|--map) ]]; then

I believe that this statement is including the whitespace before the
--reconfig since the completion is not appending the '=' when
completing --reconfig.  Maybe we should modify --list-opts to append
the '=' automatically?

Extra credit would be to have the --reconfig completion suggest namespaces.

Extra-extra credit would be to have the suggested namespaces filtered
by bus and region.


> +                       COMPREPLY[$i]="${cword}="
> +               fi
> +               ((i++))
> +       done
> +}
> +
> +__ndctl_get_buses()
> +{
> +       echo "$(ndctl list --buses | grep -E "^\s*\"provider\":" | cut -d\" -f4)"
> +}
> +
> +__ndctl_get_regions()
> +{
> +       echo "$(ndctl list --regions | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
> +}
> +
> +__ndctl_get_ns()
> +{
> +       echo "$(ndctl list --namespaces | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
> +}

Hmm, for the above 2 we might want to optionally specify "-i" to
include idle / disabled namespaces and regions, especially for the
enable-{region|namespace} case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
