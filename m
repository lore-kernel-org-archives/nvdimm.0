Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC972203B99C2
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 13:44:04 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id s198-v6so51732846oih.11
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 13:44:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180711202854.27767-1-vishal.l.verma@intel.com>
References: <20180711202854.27767-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Jul 2018 13:44:02 -0700
Message-ID: <CAPcyv4gibceAhh_cOHfCk05EP5TT7p1w29uBpvpo1HgsZaCvFA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: fix timeouts in device-dax
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 11, 2018 at 1:28 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The device-dax test used heuristic timeouts for distinction between
> cached and uncached accesses. The timeout was too short for emulated
> e820 on a virtual machine. Increased the cached timeout to ~30ms, which
> still keeps it significantly far from the cached time of 200ms.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/device-dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/test/device-dax.c b/test/device-dax.c
> index dd92f9a..46580fc 100644
> --- a/test/device-dax.c
> +++ b/test/device-dax.c
> @@ -97,7 +97,7 @@ static void sigbus(int sig, siginfo_t *siginfo, void *d)
>   * 3.00GHz where the loop, for the align == 2M case, completes in 7500us
>   * when cached and 200ms when uncached.
>   */
> -#define VERIFY_TIME(x) (suseconds_t) ((ALIGN(x, SZ_2M) / SZ_4K) * 30)
> +#define VERIFY_TIME(x) (suseconds_t) ((ALIGN(x, SZ_2M) / SZ_4K) * 60)

Looks good to me, I knew it was only a matter of time before we found
an environment that violated the expectation. Any bets on if we'll
ever need to touch it again?

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
