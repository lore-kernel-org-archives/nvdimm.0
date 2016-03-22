Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Wed, 23 Mar 2016 08:10:42 +1100
Subject: Re: [PATCH 12/12] dax: New fault locking
In-Reply-To: <20160318153919.GG7152@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz> <1457637535-21633-13-git-send-email-jack@suse.cz> <87h9gdj3dt.fsf@notabene.neil.brown.name> <87egbbh1cr.fsf@notabene.neil.brown.name> <20160318141618.GF7152@quack.suse.cz> <20160318153919.GG7152@quack.suse.cz>
Message-ID: <87h9fycj71.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain

On Sat, Mar 19 2016, Jan Kara wrote:
>
> Actually, after some thought I don't think the wakeup is needed except for
> dax_pfn_mkwrite(). In the other cases we know there is no radix tree
> exceptional entry and thus there can be no waiters for its lock...
>

I think that is fragile logic - though it may be correct at present.

A radix tree slot can transition from "Locked exception" to "unlocked
exception" to "deleted" to "struct page".

So it is absolutely certain that a thread cannot go to sleep after
finding a "locked exception" and wake up to find a "struct page" ??

How about a much simpler change.
 - new local variable "slept" in lookup_unlocked_mapping_entry() which
   is set if prepare_to_wait_exclusive() gets called.
 - if after __radix_tree_lookup() returns:
        (ret==NULL || !radix_tree_exceptional_entry(ret)) && slept
   then it calls wakeup immediately - because if it was waiting,
   something else might be to.

That would cover all vaguely possible cases except dax_pfn_mkwrite()


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW8bTSAAoJEDnsnt1WYoG5z+wP/Rr691FpPAgaMbK/8jZ92//n
Yk+dzy0NeKHIUsoOnhocDWb0pXOsSvjr9inYgJ42OxltZL6uAnn84upwNNguzE3P
+rpWxURRc3pru30VUtwGl8CHPRzkP0Pu1HoWjqUCdup17c+rYDnN7iigdmlQ9ZYu
1Kl9uwAEUGNWEy9KMCSwb1boWpQYL/wkejrN190nXPUZ7K3FTjkr2mIlezY43+no
5ZMYnQ7CGP1JdL7spvZSvTtaJ39stOxcbIqYQQ1xpFUPiqUxyDsXLFX9GP2miDRx
dCPo3OcLbKddvDFs4lNWZzOlAQ5PAzxBCCDQSLFkQMEK3kDxmZmLzr4eghEI/mc/
YTtizrh8Z7ebsEGVWHYdBslJTNIIclbIFtjYd0veT8OWoMeQgKI4dYZvBubaI0WD
KdFtTNXOtvKVz1jaoXzHxxZ0HvJIljEw3nRreOt8CG9LS9q1SsiMq8VqQPqscZ81
WhNOF780xpgH0K++V6nv0XkIW5KXeiacwY4pBaAsqhJqUSyKFwZL2+Jk/vmx+3kY
NwPpE+nRB3jqV9F2V/lmFrCkDyXQ4DDoGvWUBzJSDs7iIgLEW8Mol0QVpGFxR3xK
1iwJzWfY7Q237yk2q3e39LlMNp8twFD8Fj+KpzHfy69I5+VX2BStsWX7iy7qN+3k
J8PirHWNIvSCaiHNjucl
=hScO
-----END PGP SIGNATURE-----
--=-=-=--
