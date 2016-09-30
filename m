Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 264D21A1E05
 for <linux-nvdimm@lists.01.org>; Fri, 30 Sep 2016 15:54:00 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id w11so146730475oia.2
 for <linux-nvdimm@lists.01.org>; Fri, 30 Sep 2016 15:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1475266232-18680-1-git-send-email-vishal.l.verma@intel.com>
References: <1475266232-18680-1-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Sep 2016 15:53:58 -0700
Message-ID: <CAPcyv4iz9+Bvr2qkMjqGvV8y4S=pKLk0f6Oqobbk5h6Gg-Z=WA@mail.gmail.com>
Subject: Re: [ndctl PATCH] test/clear.sh: test to making sure cleared
 badblocks don't reappear
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

On Fri, Sep 30, 2016 at 1:10 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> From v4.9 onwards, cleared badblocks won't reappear on an ARS or simply
> after disabling/re-enabling a namespace. Add a test to make sure this
> doesn't regress.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/clear.sh | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/test/clear.sh b/test/clear.sh
> index 7765c10..336ee44 100755
> --- a/test/clear.sh
> +++ b/test/clear.sh
> @@ -69,6 +69,16 @@ if read sector len < /sys/block/$blockdev/badblocks; then
>         echo "fail: $LINENO" && exit 1
>  fi
>
> +# check for re-appearance of stale badblocks from poison_list
> +$NDCTL disable-region $BUS all
> +$NDCTL enable-region $BUS all
> +
> +# since we have cleared the errors, a disable/reenable shouldn't bring them back
> +if read sector len < /sys/block/$blockdev/badblocks; then
> +       # fail if reading badblocks returns data
> +       echo "fail: $LINENO" && exit 1
> +fi
> +

Hmm, can you gate this test by kernel version? I want to allow the
unit test suite be run with expectations set to a specific kernel
version.  We have ndctl_test_attempt() for C tests, but for shell
tests we'd want to use get_system_kver() which honors a "KVER"
environment variable.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
