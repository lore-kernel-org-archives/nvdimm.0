Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4120D81F5D
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 12:05:22 -0800 (PST)
Received: by mail-oi0-x22c.google.com with SMTP id v84so277708505oie.3
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 12:05:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706456-21111-1-git-send-email-fabf@skynet.be>
References: <1480706456-21111-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 12:05:20 -0800
Message-ID: <CAPcyv4j5Lim71MpnR1AYyqyooiXgsc1sMKcyn9w=Cc+jPaaaAA@mail.gmail.com>
Subject: Re: [PATCH 4/8 linux-next] libnvdimm, namespace: avoid multiple
 sector calculations
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
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 2, 2016 at 11:20 AM, Fabian Frederick <fabf@skynet.be> wrote:
> add cleared_sectors variable to add more readability.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/nvdimm/pmem.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 204912c..4da4735 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -52,16 +52,16 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
>  {
>         struct device *dev = to_dev(pmem);
>         sector_t sector;
> -       long cleared;
> +       long cleared, cleared_sectors;
>
>         sector = (offset - pmem->data_offset) / 512;
>         cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);

Let's skip adding a new 'cleared_sectors' variable and just adjust
cleared to be in terms of sectors.  Also, this patch collides with the
latest contents of libnvdimm-pending, please respin.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
