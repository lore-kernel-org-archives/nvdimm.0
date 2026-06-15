Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47B33E5A0C
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530239; cv=none; b=YJtd5QSRDpvZSI8EpWrmh1yJvYQ83o/X3ruPm89DMsn5w1M0J2RTv1lmtgQPQxYlQnNlX98bSR+Kdiio+TjdZoTmB6fzIbRDnJhkXchbRfIdwu/MbzyfEUALWL95liFY7Aoo5MpDQof1qbe7BEO0rbfJx53mSr49ucZ/n6FBHrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530239; c=relaxed/simple;
	bh=LGXIGJ4csUc8dv0WB+8wcc6u6scVHT1P3P0HRWfNx4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bADUlQ6ozkutBZPF9R9B2gt7xIzmujQi7OtOD3fW7FMZ53bKOnear2pY6MhBbT2ZJQuQ7wbtcyCyGlqfpr7psBwImS55egfQwEMrDNIR3w4aOQqb3Bk0hhsVpSSxfwmtF61Ng8vzB0U8KIMipfRQA99esGAU3IiFfp+cIsfBJ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47D551C443A;
	Mon, 15 Jun 2026 13:23:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf18.hostedemail.com (Postfix) with ESMTPA id 553C031;
	Mon, 15 Jun 2026 13:23:28 +0000 (UTC)
Date: Mon, 15 Jun 2026 08:23:27 -0500
From: John Groves <John@groves.net>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V5 6/9] dax/fsdev: fail probe on invalid pgmap offset
Message-ID: <ai_8vtqO6FYQfAFH@groves.net>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173225.66002-1-john@jagalactic.com>
 <0100019eb7be3bc2-972d848b-bc38-4b24-9ee1-f0dd5610355f-000000@email.amazonses.com>
 <56fbc3f1-2b26-4d8c-9a1a-42a80f2b6bdf@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56fbc3f1-2b26-4d8c-9a1a-42a80f2b6bdf@amd.com>
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 553C031
X-Stat-Signature: w1kyk6ubz3birz9y8rfbk9rpt693jy6u
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19QLsiYH2e+TW39m2EZyprxRtIXXUlxX6A=
X-HE-Tag: 1781529808-14454
X-HE-Meta: U2FsdGVkX1/8qb6Dcc7pqizPHOtCdYa2fVR8ijoQ0j8EQ70kuTjeQLlO2fZtjjg+mlWFTD5fJgbUbzCOJYJl/Ujjuoxnk2GpwOjyKOEmedqmeuh21MkLlqCodm2gNUosnAoQ9gmougrxSdtBRTQ+lQ3p/C9Qa+2+ygwzAIi9lJk6ViRVV9t3Yo1yBSGKx5RQWmFVtjK+tUq4vAKNJX1olaA5GKsGmaKiWUfpGZEm9rAX+WgJA5gI9UXbMqXvNMzhg2m3BRFbTIfJV0bG3xaflF/r/uzzAS38rSTCsX2WrzoJYFLsJmHTBUmuM7r5nlRF+mONAgOzQ4bl5JGeRcuu342Z0G8d6gO7LN5iBBjLm18I8AonRduKZSSM0cDYQiZayPGG/9mt1KmgEU7k0gLwin3+8ejVOCeGshhE1KHVV7w=

On 26/06/11 08:09PM, Gupta, Pankaj wrote:
> 
> > From: John Groves <John@Groves.net>
> > 
> > Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
> > condition means the remapped region starts after the device's data
> > region, which is an impossible state. Previously the probe continued
> > with data_offset=0, leaving virt_addr silently misaligned. Now probe
> > returns -EINVAL with a diagnostic message.
> > 
> > Fixes: 759455848df0b ("dax: Save the kva from memremap")
> > 
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

Thank you!
John

<snip>

