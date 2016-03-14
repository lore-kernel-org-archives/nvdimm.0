Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D2E81A1E09
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 08:56:45 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id m82so136791484oif.1
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 08:56:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1457970816-5625-1-git-send-email-jthumshirn@suse.de>
References: <1457970816-5625-1-git-send-email-jthumshirn@suse.de>
Date: Mon, 14 Mar 2016 08:56:26 -0700
Message-ID: <CAPcyv4i3nZOamraFAvi3mDD_ZjAaKidaR+VvP47OWGKNTw7tJA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: Bail out with unkown command in case of an
 unknown command
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 14, 2016 at 8:53 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> handle_internal_command() only returns to main if it doesn't find the
> specified command and does not set an errno.
>
> When running an unknown command you get the following error message:
> $ ./ndctl asd
> Failed to run command 'asd': Success
>
> Instead of a more appropriate:
> $ ./ndctl asd
> Unknown command: 'asd'
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  ndctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/ndctl.c b/ndctl.c
> index ded1588..18b5dc6 100644
> --- a/ndctl.c
> +++ b/ndctl.c
> @@ -159,8 +159,7 @@ int main(int argc, const char **argv)
>                 goto out;
>         }
>         handle_internal_command(argc, argv);
> -       fprintf(stderr, "Failed to run command '%s': %s\n",
> -               argv[0], strerror(errno));
> +       fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
>  out:
>         return 1;

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
