Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Wed, 16 Mar 2016 08:34:28 +1100
Subject: Re: [PATCH 12/12] dax: New fault locking
In-Reply-To: <87h9gdj3dt.fsf@notabene.neil.brown.name>
References: <1457637535-21633-1-git-send-email-jack@suse.cz> <1457637535-21633-13-git-send-email-jack@suse.cz> <87h9gdj3dt.fsf@notabene.neil.brown.name>
Message-ID: <87egbbh1cr.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain

On Fri, Mar 11 2016, NeilBrown wrote:

> On Fri, Mar 11 2016, Jan Kara wrote:
>
>> Currently DAX page fault locking is racy.
>>
>> CPU0 (write fault)		CPU1 (read fault)
>>
>> __dax_fault()			__dax_fault()
>>   get_block(inode, block, &bh, 0) -> not mapped
>> 				  get_block(inode, block, &bh, 0)
>> 				    -> not mapped
>>   if (!buffer_mapped(&bh))
>>     if (vmf->flags & FAULT_FLAG_WRITE)
>>       get_block(inode, block, &bh, 1) -> allocates blocks
>>   if (page) -> no
>> 				  if (!buffer_mapped(&bh))
>> 				    if (vmf->flags & FAULT_FLAG_WRITE) {
>> 				    } else {
>> 				      dax_load_hole();
>> 				    }
>>   dax_insert_mapping()
>>
>> And we are in a situation where we fail in dax_radix_entry() with -EIO.
>>
>> Another problem with the current DAX page fault locking is that there is
>> no race-free way to clear dirty tag in the radix tree. We can always
>> end up with clean radix tree and dirty data in CPU cache.
>>
>> We fix the first problem by introducing locking of exceptional radix
>> tree entries in DAX mappings acting very similarly to page lock and thus
>> synchronizing properly faults against the same mapping index. The same
>> lock can later be used to avoid races when clearing radix tree dirty
>> tag.
>
> Hi,
>  I think the exception locking bits look good - I cannot comment on the
>  rest.
>  I looks like it was a good idea to bring the locking into dax.c instead
>  of trying to make it generic.
>

Actually ... I'm still bothered by the exclusive waiting.  If an entry
is locked and there are two threads in dax_pfn_mkwrite() then one would
be woken up when the entry is unlocked and it will just set the TAG_DIRTY
flag and then continue without ever waking the next waiter on the
wait queue.

I *think* that any thread which gets an exclusive wakeup is responsible
for performing another wakeup.  In this case it must either lock the
slot, or call __wakeup.
That means:
  grab_mapping_entry needs to call wakeup:
     if radix_tree_preload() fails
     if radix_tree_insert fails other than with -EEXIST
     if a valid page was found
  dax_delete_mapping_entry needs to call wakeup
     if the fail case, though as that isn't expect (WARN_ON_ONCE)
        it should be a problem not to wakeup here
  dax_pfn_mkwrite needs to call wakeup unconditionally


Am I missing something?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW6H/kAAoJEDnsnt1WYoG5sisQAJJOCVv8S+t2SJ1020aa04Kz
v1eAXzR7rzcwRk50QLRJRuNzGfVFEmYoec5s3i1n1qVYUWUrOKqKBuLxndg/bA/l
/x0QPAX5OU9K5Umsov/VNQKtCq7jrtt81DwbEaIHMfLPTZhAT9xeo+ov63GZ/H3L
wLJ+G9k6fRTYYbbND1KTV17L2IW9FixF12fnA/4buqJW/2dY0Kt5+6P5EAQha1ST
M/sVSdJSfDOY+LfUhkUV1+7x9FVXF25ogbxE0hmgd9q327jCX4hs9A8ayyKPK7k+
QCGT2DOhqFwoL4s4H8O1V76YGHw6n02rD0gynvmQenfwcT5qdSMcMcd8nMFKVaVX
FxWFCUalNpyLlcF1W16oaBt28whHF/UfHmrdi/2aWlpmup5tYGZ4Rrvk+fbmdWqb
WFHcqHPItP0sLr8MDUCz3ICP0gINO4amTAkSrybQu0lfdtzs2VL2rKKxdhFjSvTW
i31S4Pz6B9yMXU5C0rviB4QEW1MnJ3A9rTE72AY4ty72BK+Mb0jZnrAS/ZsKYM2s
SQyMOutWHwMndFKEfg4fbzdiZCMkIMvysIWxKnjB5fbh8O94gDf7yfJwWZteBD06
RpEqo3Sk2fR9Tm3qKMKBZNRUK4lUwaSAF1b//f1fgBpeLXhh0Y5WXlgmiopqACVw
Ok5WWgWYSBMckV4iK4VW
=nyLa
-----END PGP SIGNATURE-----
--=-=-=--
