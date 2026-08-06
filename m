Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0EC433E79;
	Thu,  6 Aug 2026 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055455; cv=none; b=PHoq6ddZPcE0XMn7V0RzQFXPkULCJdBYe6/Lhn6uiv+OZCWlcIUElCvDfUzlu7J9V6hDo6/Q9jq5tnxCv+Li0TmL3gncyBvgmTZGxo9zACTOkhwSiDSIRnsQRXEAY2iKafE+VXBSHgoHHG16uPuVIC1FIAAEVp/PpOhk6vDbkFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055455; c=relaxed/simple;
	bh=qyHVJJ1Np197evupjuCDw3AOO9nsqP38d1h6nU3H+Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4DFkLLtjBuhFQq9NeUDvUx+miJvuKZ+QKFUnmreiKSkYQnKM3ITiS3sLR4w6hhSG6t/pPAPCRdVXD7W4USlDOgjcWgkKl+QGR6e1k/V7JBMxUxPukMF1ZnlLIbcRE/y2Uv0IHD2V04iwYOLeS4Xh7dYEV7JD/5lpPE4wP+VDpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC0C7140553;
	Thu,  6 Aug 2026 22:30:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf15.hostedemail.com (Postfix) with ESMTPA id B1F551B;
	Thu,  6 Aug 2026 22:30:27 +0000 (UTC)
Date: Thu, 6 Aug 2026 17:30:26 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 10/12] famfs: Add runtime operation-permission (opts)
 framework
Message-ID: <anUJmuNV5mFBmksw@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022950.75930-1-john@jagalactic.com>
 <0100019fc574dabe-572d99fc-3bb0-421a-afec-05432de2a757-000000@email.amazonses.com>
 <20260806053100.GJ3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806053100.GJ3560084@frogsfrogsfrogs>
X-Stat-Signature: bw5em5g91hg913xpaesgugrouo4wrfn9
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: B1F551B
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19JCa/3povowe+DVCaTZremTyrvXzE9dnQ=
X-HE-Tag: 1786055427-275828
X-HE-Meta: U2FsdGVkX19kEufDJVAy1gAj6uX2nDLCMmpAAN6usy3i1o+xi9PabxL+EioG4DkZXPut0+l8QSWoMAI3GpyQVamkZYvkiIf0/ZrhbwCamP2Bn7uXlbwx/m0WCdq5TaB/klmYruBqb+w85tYTPKSaW2J4uznKsgho/Y0ChfhKuc6JRG21vYVJGSZPvtvGXKIIrbMDgyuEVaYAS9AQ0VXNOOW9fUKpE2pboIcdZpuZaIDcguVWUExVC3d1axI8+sUl2q6zUhaJYeCKCRWI5FrXSnExsHx7SqBaOguD71asvanO+3QVIDwcfV3OxywzVd3pRmdY5gx/oUx601TQ5cF27dxii60aVlQ8DcTrGrRchmAN9zlorO5H1Eu7Nf9fXjkk

On 26/08/05 10:31PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:29:57AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > famfs denies most namespace, attribute and data operations by default
> > because the userspace log, not the kernel, is authoritative for a famfs
> > instance. Earlier commits already guard each such operation with a
> > famfs_opt_enabled(fsi, FAMFS_OPT_x) check backed by a permissive stub. This
> > commit defines the permission bitmap and makes those checks live.
> 
> Why would it ever be acceptable for user programs to mess with the
> directory tree and file attributes?  There's nothing here that would
> seem to write to the userspace log.  Or am I mistaken, and only the
> program that maintains the userspace log (e.g. the famfs server) can do
> these kinds of operations?
> 
> --D

Mostly it's the code that maintains the log that needs to create stub
files and then pass in fmaps (MAP_CREATE). Changes made via the 
"front door" of a mount are ephemeral, but allowing them can have practical
value (e.g. allowing chown/chmod, which people actually seem to need to
do sometimes. Also at one point a user sent me a patch enabling symlink
creation, because some software needed that.)

But you're right that any changes we do allow are ephemeral (not logged).

Thanks!
John

<snip>

