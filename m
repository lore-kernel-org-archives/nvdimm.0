Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3704D21A07093
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 15:39:18 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 2/8] ndctl/dimm: Add --human support to read-labels
Date: Tue, 19 Mar 2019 22:39:16 +0000
Message-ID: <6862269bbf1048a4f5d009a041627d7c1a28e4aa.camel@intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000693912.348282.3054365378477074974.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000693912.348282.3054365378477074974.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <591F0F0776D7C54B96B2245707802E8F@intel.com>
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


On Tue, 2019-02-12 at 13:28 -0800, Dan Williams wrote:
> Allow for easier comparisons between 'read-labels' output and list.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/dimm.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 292beebf9734..5ff730f42a45 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -50,6 +50,7 @@ static struct parameters {
>  	bool crypto_erase;
>  	bool overwrite;
>  	bool master_pass;
> +	bool human;

Should --human also imply --json? It doesn't make sense to have human
for binary data, so it might be surprising if --human doesn't output
json.

Also I think this is missing the man page update to add --human (and
that would be a good place to clarify the human/json behavior).

Looks good otherwise.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
