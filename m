Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C24B02095AE42
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 17:10:09 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id r203so7361690oih.0
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 17:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170818135014.8EC5.E1E9C6FF@jp.fujitsu.com>
References: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
 <20170818135014.8EC5.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Aug 2017 17:12:45 -0700
Message-ID: <CAPcyv4gz-toh76i=zMLqNpKUX93=7gjTYxwFxAmgaGyKtbq+mg@mail.gmail.com>
Subject: Re: [PATCH 3/3] acpi nfit: nfit_test supports translate SPA
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 9:50 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> nfit_test supports translate SPA
>
> To test ndctl list which use interface of Translate SPA,
> nfit_test needs to emulates it.
> This test module searches region which includes SPA and
> returns 1 dimm handle which is last one.
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
> ---
>  drivers/nvdimm/region_devs.c     |  1 +
>  tools/testing/nvdimm/test/nfit.c | 98 +++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 98 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 5954cfb..3c8cc7f 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -162,6 +162,7 @@ bool is_nd_pmem(struct device *dev)
>  {
>         return dev ? dev->type == &nd_pmem_device_type : false;
>  }
> +EXPORT_SYMBOL_GPL(is_nd_pmem);

Only a quick comment here because I need to run, but I'd like to find
a way to support this without exporting this internal detail. We
should be able to do this by just looking through the data that
nfit_test registered with the acpi driver at init time. I'll try to
think of a more concrete recommendation, but I do want the end
solution to keep is_nd_pmem private to the libnvdimm core if at all
possible.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
