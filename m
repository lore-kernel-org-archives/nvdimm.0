Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A5F4FA;
	Sat, 10 Jan 2026 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768085375; cv=none; b=jgrmLshxCZFOWndsXEBBtVIGK1hUXPVhAfls2Q81y9Ii/D9cw5CDWu6jMuSEEmDaz2f2EMTjf75pStt2S+mMkdUVke1Jyr3RrftKVqREPRobbyYtMwSNWiHeDNk6Cq2/gdbdQPEn4pBirwq470sFWgtqcQadCecPkEyJfs0r5Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768085375; c=relaxed/simple;
	bh=xoyL+D+wJRSl6ypzJUdmZipvxOzrVi1ef0l/IBs3SC8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LckOexPdsxz1EtOLZjTOMtL9cpUAapr621yx+8ai6r89oQrIHCwYgPmYs6YczhY9Fu3xjO1X/+15MQdeVMMS5vUmufcdGIRi/a0FYTNNAxsAIQUHFZJ5fPnX4Xe3bsMg+MUNDN+qnnATptvloGgzEJz+nXkqrCjWjVmQBulshZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uh4qGrI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uh4qGrI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D63C16AAE;
	Sat, 10 Jan 2026 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768085374;
	bh=xoyL+D+wJRSl6ypzJUdmZipvxOzrVi1ef0l/IBs3SC8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Uh4qGrI8dPcus4CM6ysogxmbKyjWLW/cSJcjJ5U6s+tRzeRGehtEln8+ZF0ns2dNL
	 GY0e6fq/QNt2QfI8VDg8y1vRPEaLelE+DejFZA4zhGe72eKpYGgz7Wr4klj9tNHahH
	 /MNXsTskk5yD0p0+r29cLhkcssUbsHbPIAfyhaVo=
Date: Sat, 10 Jan 2026 14:49:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: John Groves <John@Groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, John Groves
 <jgroves@micron.com>, Joao Martins <joao.m.martins@oracle.com>, Jonathan
 Cameron <Jonathan.Cameron@huawei.com>, David Hildenbrand
 <david@kernel.org>, Ying Huang <huang.ying.caritas@gmail.com>, Aravind
 Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>,
 venkataravis@micron.com, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, John Groves <john@groves.net>
Subject: Re: [PATCH V2] Add some missing kerneldoc comment fields for struct
 dev_dax
Message-Id: <20260110144933.5043d743ef01645cbe6a41dd@linux-foundation.org>
In-Reply-To: <20260110191804.5739-1-john@groves.net>
References: <20260110191804.5739-1-john@groves.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 Jan 2026 13:18:04 -0600 John Groves <John@Groves.net> wrote:

> Add the missing @align and @memmap_on_memory fields to kerneldoc comment
> header for struct dev_dax.
> 
> Also, some other fields were followed by '-' and others by ':'. Fix all
> to be ':' for actual kerneldoc compliance.
> 

Thanks, I'll queue this for 6.19-rcX, but not for -stable.

I added "drivers/dax: " to the title to aid those who skim subjects (all of
us!).

