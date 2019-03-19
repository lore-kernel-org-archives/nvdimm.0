Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22A3B2194EB70
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 16:11:30 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 4/8] ndctl/namespace: Add read-info-block command
Date: Tue, 19 Mar 2019 23:11:28 +0000
Message-ID: <544793f37222f7cbf50209f96eabbc7f5eb79eae.camel@intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000694931.348282.10012437535725994854.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000694931.348282.10012437535725994854.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <5B3E8B0B20AD104F8EBFBFE683A59825@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-02-12 at 13:29 -0800, Dan Williams wrote:
> Namespaces may contain an info-block that correlates with the possible
> modes of a namespace: 'sector', 'fsdax', or 'devdax'. Provide a command
> that can temporarily convert the namespace into 'raw' mode to read the
> info-block.
> 
> Also, similar to 'read-labels' provide a facility to decode the
> info-block into json.

Nice, I like this!

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/action.h    |    1 
>  ndctl/builtin.h   |    1 
>  ndctl/check.c     |   20 ---
>  ndctl/namespace.c |  401 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/namespace.h |   51 +++++++
>  ndctl/ndctl.c     |    1 
>  util/fletcher.h   |    1 
>  util/size.h       |    1 
>  8 files changed, 456 insertions(+), 21 deletions(-)

[..]

>  
> +#define READ_INFOBLOCK_OPTIONS() \
> +OPT_FILENAME('o', "output", &param.outfile, "output-file", \
> +	"filename to write label area contents"), \

copy/paste staleness, should be "write infoblock contents"

> +OPT_FILENAME('f', "file", &param.infile, "input-file", \
> +	"filename to readinfo block instead of a namespace"), \

Perhaps make this consistent with the label commands, and call the file
option -i/--input. This also frees up -f for --force, which might be
nice to have since the namespaces are expected to be disabled (That's
only a minor convenience thing though - I'm equally OK leaving out  the
--force for now)

> +OPT_BOOLEAN('n', "no-verify", &param.no_verify, \
> +	"skip parent uuid, and checksum validation"), \

Since the option handling framework automatically provides a no-* option
for boolean options, should we call this --verify, default to on, and
then document the availability of the automatic --no-verify option?

Currently, this ends up in an automatic --no-no-verify option :)

> +OPT_BOOLEAN('j', "json", &param.json, "parse label data into json"), \
> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats ")
> +

[..]

> +	if (mode == ACTION_READ_INFOBLOCK && param.infile && argc) {
> +		error("specify a namespace, or --file, not both\n");
> +		rc = -EINVAL;
> +	}
> +

Similar comment as read-labels about auto enabling --json if --human
supplied standalone.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
