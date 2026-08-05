Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1892746EF99;
	Wed,  5 Aug 2026 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785961351; cv=none; b=Tid+3nrkrw85Q92BMH1r9//H1fnTbqqOpiGRp+aJvR+zF+LZgPAcGuhLdt7mrLkXN9CrVtgFVdPD7FX82UnwoUGg806O6+pZEKuohC8bB4i27/rDHh3pnkXJ0SL/aMXC3yqNWktErbEME1RjcU4EjAbuis9yKhz02FKpzgAWxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785961351; c=relaxed/simple;
	bh=bjJELJGjRJBekkjijGW+YIzeuEcnI4WoOsPTOsfXV0o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=lt5FswRsQZYiKNjE+KE8Tw87p2frD+RG92MvZsff3US+93AUf+Hb4S1OeRvWUse5pkYucq02jK2NFDhR+VlLWNeM5WDjpi1HxyPaqteB3lMYeRYTJB7tDTuXvjYgmUJFs35M6AuzmQvEDKfa1Oowkc3u0Z0DEYuhEvI0h4qWcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8213B1605C1;
	Wed,  5 Aug 2026 20:22:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 5BD0732;
	Wed,  5 Aug 2026 20:22:09 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id AAF26F40067;
	Wed,  5 Aug 2026 16:22:08 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Wed, 05 Aug 2026 16:22:08 -0400
X-ME-Sender: <xms:cJtzaqR3PcOj43Cgsczq92QBAdZqSE4rgUzBdUEJwrP3VcZbke85Lg>
    <xme:cJtzaqkcaLl_vuhbW-p9boZDBJhio_iw9QDQcWSD34Bo_C3nMgHYGi9v5njzFGxyQ
    nAQVQq31ubnAYlCM9uLkDGAFyWWjwrhAHzHSeJP15hx21tVuOu_GBG->
X-ME-Proxy-Cause: dmFkZTEgN3mZ+QEJUwEqouzbGUkvs1NrM1Uf8yKq1T3bPSyNnkFsJ52RRNNRh2Ojv0XvTq
    Z8QVsL33SOtljl1piJ7lr855K8pR5Y7vEr1d0HmHBVVuzJ19uXGeP2T4DhtaxR8ejg0O+O
    amAJSE9x4EhMpfw/cMiHVekADujOdwJ7zZQzYfIAhgcP+d3gDCUK6AR7T0KCP0bsj1A2Wk
    ojgIKX+Qp2+e2qVUx3YdQoHphgGVhDr6pt5LolnLvPXMP7aOjEDwEz/sQd3PElgo9kuOE5
    qLlzWmq5Fjc3oIbCicshZzzYdPvRDGcpk142JRZ3TMyGfU1V50drAtodGGBdMfvs6mA4aT
    ZZG2mGkNRtJk/3fEw6NVGjXrh8Z0KZGaXyr72ax5akDYRLdkhKjX7PdU2c9yYqzuj/KSy3
    gqcH6WYkI/8LnM7oSG6oVOJlyCxyZ/YRIdfwh3/JFyvmZcRDO3eKpLDcfQD4tkhKcgV1x7
    DV4NsVBrNd2xfifUamdP7YSj9+4pgSSE1RICLY0F9XJgFSKlC+IehN547j3HvSTEmn8vdu
    utbsBVgSh3jyGLK+VDGYInWZPM04MobxqT+30aDj0oTRdTTnZDG2yOpCgRtJjfCvsxWf9e
    gldA57sOikCD26nKZaV4XpHJmdKE8i7EzkV+0ZWGP4z1Em0G5/4sL6U+u1VQ
X-ME-Proxy: <xmx:cJtzalGhWCkhLkFiYz-EpVbpZnouiEz2S-_6m3MLWgNKE7lG07VbxA>
    <xmx:cJtzaoBVs9nMOnn6nRRcU1rE-_yOtgPPyj7JarqC9V_l-L87AEq7_A>
    <xmx:cJtzavNOuxDG0eGaKD-nBqCFgWvZswAqCDRoHrmoXYX6Jw3NJO3A5g>
    <xmx:cJtzajfSIybCCZOX1VnfoKCV-DBmwp25nwGLFKypNWO6XwAR7J5Rhw>
    <xmx:cJtzaigYhRs_yF1j75FiHnvI58d-NkslJfhWJK6BJTQa05_7c7eCshaJ>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 71021700065; Wed,  5 Aug 2026 16:22:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 05 Aug 2026 15:21:48 -0500
From: "John Groves" <john@groves.net>
To: "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves" <john@jagalactic.com>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Dan Williams" <djbw@kernel.org>,
 "Bernd Schubert" <bschubert@ddn.com>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Jake Edge" <jake@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "David Hildenbrand" <david@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jonathan Cameron" <jic23@kernel.org>,
 "Stefan Hajnoczi" <shajnocz@redhat.com>,
 "Joanne Koong" <joannelkoong@gmail.com>,
 "Josef Bacik" <josef@toxicpanda.com>,
 "Bagas Sanjaya" <bagasdotme@gmail.com>,
 "Chen Linxuan" <chenlinxuan@uniontech.com>,
 "James Morse" <james.morse@arm.com>, "Fuad Tabba" <tabba@google.com>,
 "Sean Christopherson" <seanjc@google.com>,
 "Shivank Garg" <shivankg@amd.com>,
 "Ackerley Tng" <ackerleytng@google.com>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Ira Weiny" <iweiny@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Haren Myneni" <haren@linux.ibm.com>,
 "Pratyush Yadav" <pratyush@kernel.org>,
 "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>,
 "Jiri Slaby" <jirislaby@kernel.org>,
 "Ethan Nelson-Moore" <enelsonmoore@gmail.com>,
 "Gabriel Whigham" <gabewhigham@gmail.com>,
 "Aravind Ramesh" <arramesh@micron.com>,
 "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Message-Id: <94e39ae2-08e5-4606-a43a-d4a8ca71cdae@app.fastmail.com>
In-Reply-To: <anDoPTHjlOPhnnR-@aschofie-mobl2.lan>
References: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022817.75759-1-john@jagalactic.com>
 <0100019fc5737596-636bde4f-7fc7-46a4-b011-63870098df09-000000@email.amazonses.com>
 <anDoPTHjlOPhnnR-@aschofie-mobl2.lan>
Subject: Re: [PATCH V12 01/12] dax: replace exported dax_dev_get() with non-allocating
 dax_dev_find()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b188p7q6x6rdo47trbfafeefzjhknazn
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 5BD0732
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18vLKW3a6wRLmy0PcxyeH7L133BOHb78wo=
X-HE-Tag: 1785961329-990005
X-HE-Meta: U2FsdGVkX1+LVTZHsSvYpNndp/Qc+FC7te14b6PbXuGr7dm4qoVpu6X0SWbLKkmkOBUorTVCqub7oknHL+UTVkG4A5RLa8CC2dxPBL//mUw9u6e6/56yBiKLZ33tKGVODYIH9zink/kH+tR78Yg6zbegX6JwZ3QdUE+3HVaXB7/WGQduQt9hf77uUKNSXe/3+Mvk69fkz6Mzwo7x7JensRaAd9lZkEogV44MSQQY5M8ArAaJzpVdygbHq9NSYnKixUiQuQ+GsD3hz6WAsQNnmQduN+ofjAm25FmIeEdccB56Dx4rBb2e4bxKO9pRXipjp1L7LLzVoSgr8mqSPu65p1t4l//x+pwJTFLAptqkcTjxZcjeL3tM/YmYg31hDHLgD8EEhCgmZev7NnKv76KL4g==



On Mon, Aug 3, 2026, at 2:13 PM, Alison Schofield wrote:
> On Mon, Aug 03, 2026 at 02:28:26AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > This fix is in response to a Sashiko review, and some subsequent
> > analysis.
> > 
> > dax_dev_get() uses iget5_locked() which creates a new inode if no
> > matching one exists. This is correct for the internal caller
> > (alloc_dax), but dangerous for external callers that look up devices
> > from user-supplied or metadata-supplied dev_t values:
> > 
> > 1. A new inode is created with DAXDEV_ALIVE set but no backing driver,
> >    no ops, and no IDA-allocated minor number.
> > 
> > 2. On teardown, dax_destroy_inode() warns because kill_dax() was never
> >    called, and dax_free_inode() calls ida_free() for a minor that was
> >    never ida_alloc'd -- potentially freeing the minor of a real device.
> > 
> > Add dax_dev_find() which uses ilookup5() for lookup-only semantics:
> > it returns an existing dax_device with an elevated inode reference, or
> > NULL if no device with the given dev_t exists. It never creates inodes.
> > A dax_alive() check under dax_read_lock() guards against returning a
> > device that is concurrently being torn down by kill_dax().
> > 
> > Make dax_dev_get() static again (internal to super.c for alloc_dax),
> > export dax_dev_find() instead, and update the two external callers
> > (famfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=n stub.
> 
> There are no external callers yet as those arrive in subsequent
> famfs patches.
> 
> 
> > 
> > About the 'fixes' tag: this removes the export of dax_dev_get(),
> > which was flawed, and replaces is with dax_dev_find(). It feels like
> > the fixes tag makes sense for correcting an ABI error.
> > 
> > Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
> 
> Hi John,
> 
> I think this should be split.
> 
> Please send a standalone DAX patch that only removes the dax_dev_get()
> export (make it static again, drop the header declaration). It's unused
> in-tree and unsafe for its intended use, so it stands on its own with
> no FAMFS dependency. I'll take it through the DAX tree for 7.3.
> 
> Please drop the Fixes: tag on the removal. IIUC the stable team uses
> it to pick backports, and this shouldn't land in 7.2.y. Removing this
> fixes nothing since no in-tree code calls the symbol. Name the commit
> in prose instead, something like:
> 
>   Commit 2ae624d5a555 ("dax: export dax_dev_get()") exported
>   dax_dev_get() in v7.2 for famfs, which has not merged. The export
>   has never had an in-tree caller, so make dax_dev_get() static again.
> 
> Keep the dax_dev_find() addition in this famfs series, so the new export
> lands with famfs.
> 
> -- Alison
> 
> > 
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> I think you can carry the tags for both patches because the code
> should end up byte identical.
> 
> snip
> 

Thanks Alison, done in my local tree.

The patch that drops dev_dax_get() should hit your inbox today or tomorrow;
the one that adds dev_dax_find() will stay with this series.

Best,
John
