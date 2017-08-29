Return-Path: <dan.j.williams@intel.com>
MIME-Version: 1.0
In-Reply-To: <20170825204922.29374-1-stellarhopper@gmail.com>
References: <20170825204922.29374-1-stellarhopper@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:13:07 -0700
Message-ID: <CAPcyv4iTAk=+tGdCKY4Xq78Eg9cTDSTjR9QtXGWFETyn1iehDA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, bash_completion: add completion for --sector-size=
Content-Type: text/plain; charset="UTF-8"
To: Vishal Verma <stellarhopper@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 25, 2017 at 1:49 PM, Vishal Verma <stellarhopper@gmail.com> wrote:
> Sector size options were missing completion. Add completion based on the
> mode of the namespace if specified. 'raw' and 'memory' can only do 512
> or 4096, where as with 'sector', more sector sizes are possible. 'dax'
> doesn't accept a sector size option, so refrain from completing that.
>
> $ ndctl create-namespace --mode=sector --sector-size=
> 4096   4104   4160   4224   512    520    528
>
> $ ndctl create-namespace --mode=dax --sector-size=
> <blank>
>
> $ ndctl create-namespace --mode=raw --sector-size=
> 4096   512
>
> When no mode has been specified yet, it is open game, and everything is
> shown.
>
> $ ndctl create-namespace --sector-size=
> 4096   4104   4160   4224   512    520    528
>
> Signed-off-by: Vishal Verma <stellarhopper@gmail.com>

Looks good to me, applied.
