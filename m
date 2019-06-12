Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D55221290DF3
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 16:20:22 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id s184so12998174oie.9
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 16:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190612230845.GA13679@alison-desk.jf.intel.com>
In-Reply-To: <20190612230845.GA13679@alison-desk.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Jun 2019 16:20:11 -0700
Message-ID: <CAPcyv4iF5cDoNB4e3GF0_HJRbxn+VWk=5QKuEk4wBWWn66AUvA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: handle backup_keys in security.sh
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
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 12, 2019 at 4:05 PM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> Fix a typo in security.sh that causes a script failure
> when an nvdimm-master.blob already exists and needs to
> be backed up.
>
> + setup_keys
> + '[' '!' -d /etc/ndctl/keys ']'
> + '[' -f /etc/ndctl/keys/nvdimm-master.blob ']'
> + mv /etc/ndctl/keys/nvdimm-master.blob /etc/ndctl/keys/nvdimm-master.blob.bak
> + 0=1
> ./security.sh: line 39: 0=1: command not found
>
> Fixes: ba35642d3815 ("ndctl: add a load-keys test in the security unit test")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/security.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/test/security.sh b/test/security.sh
> index 8a36265..c86d2c6 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -36,11 +36,11 @@ setup_keys()
>
>         if [ -f "$masterpath" ]; then
>                 mv "$masterpath" "$masterpath.bak"
> -               $backup_key=1
> +               backup_key=1
>         fi
>         if [ -f "$keypath/tpm.handle" ]; then
>                 mv "$keypath/tpm.handle" "$keypath/tmp.handle.bak"
> -               $backup_handle=1
> +               backup_handle=1
>         fi

Looks obviously correct to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...but that said, why is this test even bothering with the host's
configuration? I think it should be using a test local directory that
does not disturb the rest of the system, especially because the test
is using nfit_test resources.

There's no guarantee that the script successfully reaches the
post_cleanup() phase to restore the host configuration and could leave
it broken. Unless / until we can fix up this test to not touch /etc I
think it should be moved to the ENABLE_DESTRUCTIVE set of tests.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
