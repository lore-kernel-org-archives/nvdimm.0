Return-Path: <owner-linux-mm@kvack.org>
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v3 2/2] mm/memory-failure: Poison read receives SIGKILL
 instead of SIGBUS if mmaped more than once
Date: Thu, 1 Aug 2019 08:17:37 +0000
Message-ID: <20190801081737.GA31767@hori.linux.bs1.fc.nec.co.jp>
References: <1564092101-3865-1-git-send-email-jane.chu@oracle.com>
 <1564092101-3865-3-git-send-email-jane.chu@oracle.com>
In-Reply-To: <1564092101-3865-3-git-send-email-jane.chu@oracle.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <372749A4D6FFC14982F5FD30BC1E06A7@gisp.nec.co.jp>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Jane Chu <jane.chu@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 25, 2019 at 04:01:41PM -0600, Jane Chu wrote:
> Mmap /dev/dax more than once, then read the poison location using address
> from one of the mappings. The other mappings due to not having the page
> mapped in will cause SIGKILLs delivered to the process. SIGKILL succeeds
> over SIGBUS, so user process looses the opportunity to handle the UE.
>=20
> Although one may add MAP_POPULATE to mmap(2) to work around the issue,
> MAP_POPULATE makes mapping 128GB of pmem several magnitudes slower, so
> isn't always an option.
>=20
> Details -
>=20
> ndctl inject-error --block=3D10 --count=3D1 namespace6.0
>=20
> ./read_poison -x dax6.0 -o 5120 -m 2
> mmaped address 0x7f5bb6600000
> mmaped address 0x7f3cf3600000
> doing local read at address 0x7f3cf3601400
> Killed
>=20
> Console messages in instrumented kernel -
>=20
> mce: Uncorrected hardware memory error in user-access at edbe201400
> Memory failure: tk->addr =3D 7f5bb6601000
> Memory failure: address edbe201: call dev_pagemap_mapping_shift
> dev_pagemap_mapping_shift: page edbe201: no PUD
> Memory failure: tk->size_shift =3D=3D 0
> Memory failure: Unable to find user space address edbe201 in read_poison
> Memory failure: tk->addr =3D 7f3cf3601000
> Memory failure: address edbe201: call dev_pagemap_mapping_shift
> Memory failure: tk->size_shift =3D 21
> Memory failure: 0xedbe201: forcibly killing read_poison:22434 because of =
failure to unmap corrupted page
>   =3D> to deliver SIGKILL
> Memory failure: 0xedbe201: Killing read_poison:22434 due to hardware memo=
ry corruption
>   =3D> to deliver SIGBUS
>=20
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/memory-failure.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>=20
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 51d5b20..f668c88 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -199,7 +199,6 @@ struct to_kill {
>  	struct task_struct *tsk;
>  	unsigned long addr;
>  	short size_shift;
> -	char addr_valid;
>  };
> =20
>  /*
> @@ -318,22 +317,27 @@ static void add_to_kill(struct task_struct *tsk, st=
ruct page *p,
>  	}
> =20
>  	tk->addr =3D page_address_in_vma(p, vma);
> -	tk->addr_valid =3D 1;
>  	if (is_zone_device_page(p))
>  		tk->size_shift =3D dev_pagemap_mapping_shift(p, vma);
>  	else
>  		tk->size_shift =3D compound_order(compound_head(p)) + PAGE_SHIFT;
> =20
>  	/*
> -	 * In theory we don't have to kill when the page was
> -	 * munmaped. But it could be also a mremap. Since that's
> -	 * likely very rare kill anyways just out of paranoia, but use
> -	 * a SIGKILL because the error is not contained anymore.
> +	 * Send SIGKILL if "tk->addr =3D=3D -EFAULT". Also, as
> +	 * "tk->size_shift" is always non-zero for !is_zone_device_page(),
> +	 * so "tk->size_shift =3D=3D 0" effectively checks no mapping on
> +	 * ZONE_DEVICE. Indeed, when a devdax page is mmapped N times
> +	 * to a process' address space, it's possible not all N VMAs
> +	 * contain mappings for the page, but at least one VMA does.
> +	 * Only deliver SIGBUS with payload derived from the VMA that
> +	 * has a mapping for the page.
>  	 */
> -	if (tk->addr =3D=3D -EFAULT || tk->size_shift =3D=3D 0) {
> +	if (tk->addr =3D=3D -EFAULT) {=20
                              ^
(sorry nitpicking...) there's a trailing whitespace.
Otherwise looks good to me.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

>  		pr_info("Memory failure: Unable to find user space address %lx in %s\n=
",
>  			page_to_pfn(p), tsk->comm);
> -		tk->addr_valid =3D 0;
> +	} else if (tk->size_shift =3D=3D 0) {
> +		kfree(tk);
> +		return;
>  	}
> =20
>  	get_task_struct(tsk);
> @@ -361,7 +365,7 @@ static void kill_procs(struct list_head *to_kill, int=
 forcekill, bool fail,
>  			 * make sure the process doesn't catch the
>  			 * signal and then access the memory. Just kill it.
>  			 */
> -			if (fail || tk->addr_valid =3D=3D 0) {
> +			if (fail || tk->addr =3D=3D -EFAULT) {
>  				pr_err("Memory failure: %#lx: forcibly killing %s:%d because of fail=
ure to unmap corrupted page\n",
>  				       pfn, tk->tsk->comm, tk->tsk->pid);
>  				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,
> --=20
> 1.8.3.1
>=20
> =
