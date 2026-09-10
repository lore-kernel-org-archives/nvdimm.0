Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A66420496;
	Thu, 10 Sep 2026 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027538; cv=none; b=VxudNFrN+99qEhK3hB3dyfKJoZQOdugNOnMcfww/CJ86PQynM2UE2Gju2ezFanJvUH2dHomcIjiaSq0U2ATS49KavTqQzk51hnmkqqzQWo2MAahGb1JDuaPpR0QTQSl8gLxaUutN3ycEOo6FXZ25lJLBZ7O5xjLzNDvz7hAfqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027538; c=relaxed/simple;
	bh=Co/xDGyGBm71ZNsClBUBL2FknCJYkPSGnzGLjnGPnv4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=su0hixHAeKGLCL4QpKBUC+QwTzqkU8DPGsepU6Coinl6KxceYCWVqTb3mtoi9AJnAvL6q3t6jashW0Q/Kb9uUe91gE5Kql+HJhkKAsAIt+NmKI9FSVrN3C4cV3vZK+hP3ocXu+YJ85Gyk+g/lm1Z3qAhLzEYTNAGenGMabmNs8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erHB84hB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erHB84hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154CE1F000FF;
	Thu, 10 Sep 2026 08:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789027537;
	bh=6/2XfJC86Fm/Ad/wm4hX1MWJfptljS23xiR21EMrGbc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=erHB84hBAIebbCGO0Kuj8g+pDl4x0Y2EJYaU0+8UMfx4Qh2uhStkAbm7Pf5t5xLUr
	 xM1fZc53eUw6Qg+UwT5KSGVOBQEAVoafbEuTu8advWHSHF+Wgs7jJlHyjLsqYAhl4i
	 S8LAkx9+wckIJShKUwvLqM9v+X3twZzF3NM9CbmpTorcf9PlUxOc8RFv705fc6GkAT
	 v3UekI/YBsnH/zvnWo5VV3cXRHcHTUb2Aq4lahX3f9UB8hdBsm8el9aRhJdDEEVNPt
	 NTbms2jxVq3Jq7PfHJS6UeoTbRmfZM7n67ZLmmixQdR0HZ7It0n+kwOF7sRAkkvvzJ
	 XEWHLWyjpf/mA==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
In-Reply-To: <20260904152749.84493-1-kaitao.cheng@linux.dev>
References: <20260904152749.84493-1-kaitao.cheng@linux.dev>
Subject: Re: [PATCH 0/2] fs/dax: Clean up busy page lookup helpers
Message-Id: <20260910-getappt-rundreise-aromen-858ffbf41406@brauner>
Date: Thu, 10 Sep 2026 10:05:29 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1328; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Co/xDGyGBm71ZNsClBUBL2FknCJYkPSGnzGLjnGPnv4=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqiZMyiPX+nmQud3pHo+LH1RfDUmJt0BnYDYrr9eHfVKYdPt
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqiZMwACgkQkcYbwGV43KKyagEA4whf
 JOmXgUnRJSjjTsB6BByqnoi3U6tWgeQyArk18LMA/Rhk+gx2xCwFNQF1af2xGr2ApQoq7FfAVW8
 yu0D4Zn8C
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Fri, 04 Sep 2026 23:27:47 +0800, Kaitao Cheng wrote:
> fs/dax: Clean up busy page lookup helpers
> 
> The dax_layout_busy_page() and dax_layout_busy_page_range() helpers were
> originally exposed so filesystems could find pinned DAX pages before
> changing file layouts. Filesystem callers now use dax_break_layout(),
> which provides the complete operation, leaving no direct users of these
> lookup helpers outside fs/dax.c.
> 
> [...]

Applied to the vfs-7.4.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.misc

[1/2] fs/dax: Remove unused dax_layout_busy_page()
      https://git.kernel.org/vfs/vfs/c/cc939930c450
[2/2] fs/dax: Make dax_layout_busy_page_range() static
      https://git.kernel.org/vfs/vfs/c/24bf180c869b

