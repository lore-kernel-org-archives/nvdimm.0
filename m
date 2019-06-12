Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9BE021290DF3
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jun 2019 16:19:35 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: handle backup_keys in security.sh
Date: Wed, 12 Jun 2019 23:19:33 +0000
Message-ID: <e5e78c171ca03670c10ee8e2b1ab98a13cd1b556.camel@intel.com>
References: <20190612230845.GA13679@alison-desk.jf.intel.com>
In-Reply-To: <20190612230845.GA13679@alison-desk.jf.intel.com>
Content-Language: en-US
Content-ID: <28D67F7278FB654A8F01A5030860C282@intel.com>
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
To: "Schofield, Alison" <alison.schofield@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-06-12 at 16:08 -0700, Alison Schofield wrote:
> Fix a typo in security.sh that causes a script failure
> when an nvdimm-master.blob already exists and needs to
> be backed up.
> 
> + setup_keys
> + '[' '!' -d /etc/ndctl/keys ']'
> + '[' -f /etc/ndctl/keys/nvdimm-master.blob ']'
> + mv /etc/ndctl/keys/nvdimm-master.blob /etc/ndctl/keys/nvdimm-
> master.blob.bak
> + 0=1
> ./security.sh: line 39: 0=1: command not found
> 
> Fixes: ba35642d3815 ("ndctl: add a load-keys test in the security unit
> test")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/security.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good, I'll pick it up for v66 and push it out to pending shortly.

> 
> diff --git a/test/security.sh b/test/security.sh
> index 8a36265..c86d2c6 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -36,11 +36,11 @@ setup_keys()
>  
>  	if [ -f "$masterpath" ]; then
>  		mv "$masterpath" "$masterpath.bak"
> -		$backup_key=1
> +		backup_key=1
>  	fi
>  	if [ -f "$keypath/tpm.handle" ]; then
>  		mv "$keypath/tpm.handle" "$keypath/tmp.handle.bak"
> -		$backup_handle=1
> +		backup_handle=1
>  	fi
>  
>  	dd if=/dev/urandom bs=1 count=32 2>/dev/null | keyctl padd user
> "$masterkey" @u

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
