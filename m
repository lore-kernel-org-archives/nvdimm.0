Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB94181C63
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:55:41 -0800 (PST)
Received: by mail-oi0-x233.google.com with SMTP id v84so277415929oie.3
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 11:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706506-21222-1-git-send-email-fabf@skynet.be>
References: <1480706506-21222-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 11:55:40 -0800
Message-ID: <CAPcyv4gFswm=C-vXZ4fK3cndzpXN7nDz5VzpKESjtd01Fp2PRg@mail.gmail.com>
Subject: Re: [PATCH 6/8 linux-next] libnvdimm,
 namespace: use octal for permissions
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

On Fri, Dec 2, 2016 at 11:21 AM, Fabian Frederick <fabf@skynet.be> wrote:
> According to commit f90774e1fd27
> ("checkpatch: look for symbolic permissions and suggest octal instead")
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/nvdimm/namespace_devs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index b00045b..0d2da9a 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1132,7 +1132,7 @@ static ssize_t size_show(struct device *dev,
>         return sprintf(buf, "%llu\n", (unsigned long long)
>                         nvdimm_namespace_capacity(to_ndns(dev)));
>  }
> -static DEVICE_ATTR(size, S_IRUGO, size_show, size_store);
> +static DEVICE_ATTR(size, 0444, size_show, size_store);
>
>  static u8 *namespace_to_uuid(struct device *dev)
>  {
> @@ -1456,7 +1456,7 @@ static umode_t namespace_visible(struct kobject *kobj,
>
>         if (is_namespace_pmem(dev) || is_namespace_blk(dev)) {
>                 if (a == &dev_attr_size.attr)
> -                       return S_IWUSR | S_IRUGO;
> +                       return 0200 | 0444;

If we're going to use octal just go to "0644" directly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
