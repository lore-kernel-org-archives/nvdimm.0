Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 494D11A1F23
 for <linux-nvdimm@lists.01.org>; Thu, 26 May 2016 14:23:21 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id b65so144893819oia.1
 for <linux-nvdimm@lists.01.org>; Thu, 26 May 2016 14:23:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464295925-23772-1-git-send-email-vishal.l.verma@intel.com>
References: <1464295925-23772-1-git-send-email-vishal.l.verma@intel.com>
Date: Thu, 26 May 2016 14:23:09 -0700
Message-ID: <CAPcyv4jvBooJrwNet1qaYQ8kgKcN=rsXY==-+Y248PKydWeqGA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, btt: update the usage section in Documentation
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

On Thu, May 26, 2016 at 1:52 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Section 5 about BTT's in kernel usage was quite obsolete,
> replace it with a simple 'Usage' section that describes how
> to set up a BTT namespace using the 'ndctl' utility.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/nvdimm/btt.txt | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
>
> diff --git a/Documentation/nvdimm/btt.txt b/Documentation/nvdimm/btt.txt
> index b91443f..e9d4881 100644
> --- a/Documentation/nvdimm/btt.txt
> +++ b/Documentation/nvdimm/btt.txt
> @@ -256,28 +256,18 @@ If any of these error conditions are encountered, the arena is put into a read
>  only state using a flag in the info block.
>
>
> -5. In-kernel usage
> -==================
> +5. Usage
> +========
>
> -Any block driver that supports byte granularity IO to the storage may register
> -with the BTT. It will have to provide the rw_bytes interface in its
> -block_device_operations struct:
> +The BTT can be set up on any disk (namespace) exposed by the libnvdimm subsystem
> +(pmem, or blk mode). The easiest way to set up such a namespace is using the
> +'ndctl' utility [1]:
>
> -       int (*rw_bytes)(struct gendisk *, void *, size_t, off_t, int rw);
> +Then the ndctl command line to setup a btt with a 4k sector size is:

maybe s/Then/For example,/

>
> -It may register with the BTT after it adds its own gendisk, using btt_init:
> +    ndctl create-namespace -f -e namespace0.0 -m sector -l 4k
>
> -       struct btt *btt_init(struct gendisk *disk, unsigned long long rawsize,
> -                       u32 lbasize, u8 uuid[], int maxlane);
> +See ndctl create-namespace --help for more options.
>
> -note that maxlane is the maximum amount of concurrency the driver wishes to
> -allow the BTT to use.
> -
> -The BTT 'disk' appears as a stacked block device that grabs the underlying block
> -device in the O_EXCL mode.
> -
> -When the driver wishes to remove the backing disk, it should similarly call
> -btt_fini using the same struct btt* handle that was provided to it by btt_init.
> -
> -       void btt_fini(struct btt *btt);
> +[1]: https://github.com/pmem/ndctl
>

Otherwise, looks good.

Thanks Vishal!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
