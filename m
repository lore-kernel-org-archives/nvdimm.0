Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Thu, 31 Mar 2016 15:20:00 +1100
Subject: Re: [PATCH 12/12] dax: New fault locking
In-Reply-To: <20160323110011.GD4512@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz> <1457637535-21633-13-git-send-email-jack@suse.cz> <87h9gdj3dt.fsf@notabene.neil.brown.name> <87egbbh1cr.fsf@notabene.neil.brown.name> <20160318141618.GF7152@quack.suse.cz> <20160318153919.GG7152@quack.suse.cz> <87h9fycj71.fsf@notabene.neil.brown.name> <20160323110011.GD4512@quack.suse.cz>
Message-ID: <87oa9vs2hb.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 23 2016, Jan Kara wrote:

> On Wed 23-03-16 08:10:42, NeilBrown wrote:
>> On Sat, Mar 19 2016, Jan Kara wrote:
>> >
>> > Actually, after some thought I don't think the wakeup is needed except=
 for
>> > dax_pfn_mkwrite(). In the other cases we know there is no radix tree
>> > exceptional entry and thus there can be no waiters for its lock...
>> >
>>=20
>> I think that is fragile logic - though it may be correct at present.
>>=20
>> A radix tree slot can transition from "Locked exception" to "unlocked
>> exception" to "deleted" to "struct page".
>
> Yes.
>=20=20
>> So it is absolutely certain that a thread cannot go to sleep after
>> finding a "locked exception" and wake up to find a "struct page" ??
>
> With current implementation this should not happen but I agree entry
> locking code should not rely on this.
>
>> How about a much simpler change.
>>  - new local variable "slept" in lookup_unlocked_mapping_entry() which
>>    is set if prepare_to_wait_exclusive() gets called.
>>  - if after __radix_tree_lookup() returns:
>>         (ret=3D=3DNULL || !radix_tree_exceptional_entry(ret)) && slept
>>    then it calls wakeup immediately - because if it was waiting,
>>    something else might be to.
>>=20
>> That would cover all vaguely possible cases except dax_pfn_mkwrite()
>
> But how does this really help? If lookup_unlocked_mapping_entry() finds
> there is no entry (and it was there before), the process deleting the ent=
ry
> (or replacing it with something else) is responsible for waking up
> everybody.

"everybody" - yes.  But it doesn't wake everybody does it?  It just
wakes one.

+		__wake_up(wq, TASK_NORMAL, 1, &key);
                                           ^one!

Or am I misunderstanding how exclusive waiting works?

Thanks,
NeilBrown

>             So your change would only duplicate what
> dax_delete_mapping_entry() does. The potential for breakage is that calle=
rs
> of lookup_unlocked_mapping_entry() are responsible for waking up other
> waiters *even if* they do not lock or delete the entry in the end. Maybe
> I'll rename lookup_unlocked_mapping_entry() to get_unlocked_mapping_entry=
()
> so that it is clearer that one must call either put_unlocked_mapping_entr=
y()
> or put_locked_mapping_entry() on it.
>
> 								Honza
>
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/KVwAAoJEDnsnt1WYoG5yR8P/RjPn1Ru9B4VoKWRSiTUaLfs
Lkj7TsIcuF1+BcZ2lvE/zA/qYBR5+gbBfpoWnM3LFlwb5zzkjQuyr6dFMxY04vxg
PlUKud9JTe7cmFer0ya2kl2y5kT/NJgqeMEuGqwlEK8KIswbv0ZfL/ymX4H5OQB2
IjERQGYHVTkI8t9qG/H9jzZv7UodxAX9T2GGDgYUAa/VfWpSW8YBLSSzAlm1W5Jg
UkkjZMbxXtbLJYuvobiAbQ1SW3qJCyV8duG/MLdGeEn8hPfrX6MAt/UMOY9bIKG7
CZjJ3cY/o2dlglBvqYbscLnFrbBTUsX3hukYK/5Q9WbfVMuwEHG+pPLlVnk9KbN1
QRaMDN/AqW2Zz3JB0xXUxrWyx5pUm1EBjrLFnMz21GXcWFKV85P63Ial82hgI1/7
T7gUln1QJNlnNOLta8kO5iPl4LXFhhWTLyCCi2QeV6RbBwmxPxqa7ssKh6Q2i5Fk
mHS3nQufypGe/XoTNqEjiyLH49t6aUs1VMg/GBX7j+sNQWtypALntAcygd+Rpq4t
Sq/YZhlIKUYzzvAyRfSss02P92GFWivW/JHfQoL6cloFuHUNHsRxPdFkLSK46wVj
gpUtN+PdY0n3Cq9zS9SJ1Y/QvaGCmiWVUOyavY1F0r8C8QuhRfv24LIsrUskEHCY
QvRKfcgOymOdtjduSfCr
=UsMR
-----END PGP SIGNATURE-----
--=-=-=--
