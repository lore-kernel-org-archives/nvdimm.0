Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <F454DBB5-FF0B-46F7-B1D8-40764AAC4657@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FCD1889E-4F22-46C5-9BCC-A75FFB283D0A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 7/9] ext4: prevent data corruption with inline data + DAX
Date: Wed, 6 Sep 2017 14:55:31 -0600
In-Reply-To: <20170905223541.20594-8-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <20170905223541.20594-8-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-nvdimm@lists.01.org, xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


--Apple-Mail=_FCD1889E-4F22-46C5-9BCC-A75FFB283D0A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 5, 2017, at 4:35 PM, Ross Zwisler <ross.zwisler@linux.intel.com> =
wrote:
>=20
> If an inode has inline data it is currently prevented from using DAX =
by a
> check in ext4_should_use_dax().  When the inode grows inline data via
> ext4_create_inline_data() or removes its inline data via
> ext4_destroy_inline_data_nolock(), the value of S_DAX can change.
>=20
> Currently these changes are unsafe because we don't hold off page =
faults
> and I/O, write back dirty radix tree entries and invalidate all =
mappings.
> This work is done in XFS via xfs_ioctl_setattr_dax_invalidate(), for
> example.  This unsafe transitioning of S_DAX could potentially lead to =
data
> corruption.
>=20
> Fix this issue by preventing the DAX mount option from being used on
> filesystems that were created to support inline data.  Inline data is =
an
> option given to mkfs.ext4.
>=20
> We prevent DAX from being used with inline data as opposed to trying =
to
> safely manage the transition of S_DAX because of the locking =
complexities:
>=20
> 1) filemap_write_and_wait() eventually calls ext4_writepages(), which
> acquires the sbi->s_journal_flag_rwsem.  This lock ranks above the
> jbdw_handle which is eventually taken by ext4_journal_start().  This
> essentially means that the writeback has to happen outside of the =
context
> of an active journal handle (outside of ext4_journal_start() to
> ext4_journal_stop().)
>=20
> 2) To lock out page faults we take a write lock on the ei->i_mmap_sem, =
and
> this lock again ranks above the jbd2_handle taken by =
ext4_journal_start().
> So, as with the writeback code in 1) above we have to take =
ei->i_mmap_sem
> outside of the context of an active journal handle.
>=20
> We are able to work around both of these restrictions and safely =
transition
> S_DAX when we change the journaling mode, but for inline data it's =
much
> harder because each of ext4_create_inline_data() and
> ext4_destroy_inline_data_nolock() are passed in journal handles that =
have
> already been started.
>=20
> To be able to safely writeback and invalidate our dirty inode data =
we'd
> either need to uplevel the locking, writeback and invalidate into all =
the
> callers of those two functions, or we'd need to stop our current =
journal
> handle, do the appropriate locking, writeback and invalidate, unlock =
and
> restart the journal handle.
>=20
> These both seem too complex, and I don't know if we have a valid use =
case
> where we need to combine a filesystem with inline data and DAX, so =
just
> prevent them from being used together.

The one reason I can see to use inline data + DAX is that inline data =
saves
space for very small files, even if the performance improvement is =
minimal.
Since NVDIMMs are still relatively expensive, storing very small files =
and
directories directly in the inode is probably worthwhile.

That said, there are still occasional bugs in the inline data code, so =
it
makes sense to ensure these two features are not enabled at the same =
time
if they don't play well together.

> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> CC: stable@vger.kernel.org
> ---
> fs/ext4/inline.c | 10 ----------
> fs/ext4/super.c  |  5 +++++
> 2 files changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 28c5c3a..fd95019 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -302,11 +302,6 @@ static int ext4_create_inline_data(handle_t =
*handle,
> 	EXT4_I(inode)->i_inline_size =3D len + =
EXT4_MIN_INLINE_DATA_SIZE;
> 	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> 	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> -	/*
> -	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
> -	 * get cleared
> -	 */
> -	ext4_set_inode_flags(inode);

What about other flags in the inode?  It doesn't make sense to drop this
entirely.  The S_DAX flag shouldn't be set if the inode has the inline
data flag set, according to ext4_set_inode_flags().

> 	get_bh(is.iloc.bh);
> 	error =3D ext4_mark_iloc_dirty(handle, inode, &is.iloc);
>=20
> @@ -451,11 +446,6 @@ static int =
ext4_destroy_inline_data_nolock(handle_t *handle,
> 		}
> 	}
> 	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> -	/*
> -	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
> -	 * get set.
> -	 */
> -	ext4_set_inode_flags(inode);

Same?

> 	get_bh(is.iloc.bh);
> 	error =3D ext4_mark_iloc_dirty(handle, inode, &is.iloc);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d61a70e2..d549dfb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3686,6 +3686,11 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	}
>=20
> 	if (sbi->s_mount_opt & EXT4_MOUNT_DAX) {
> +		if (ext4_has_feature_inline_data(sb)) {
> +			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a =
filesystem"
> +					" that may contain inline =
data");
> +			goto failed_mount;
> +		}

Wouldn't it be enough to just prevent modification of inodes that are =
stored
in the inode?  It should be OK to read such files.  At a minimum that =
means
there should not be an error in case of read-only mounting.  A better =
choice
would be to return an error only at runtime in case of open-for-write, =
or
only if the file is actually being written.

Cheers, Andreas






--Apple-Mail=_FCD1889E-4F22-46C5-9BCC-A75FFB283D0A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZsGDEpIg59Q01vtYRApAMAKDw152Rv9VhplecqgisxrI9h6e99QCfdfVQ
hhMRFUZkIT2e3LORyGnYELA=
=MDp3
-----END PGP SIGNATURE-----

--Apple-Mail=_FCD1889E-4F22-46C5-9BCC-A75FFB283D0A--
