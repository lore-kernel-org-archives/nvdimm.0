Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E6549B20C;
	Fri,  4 Sep 2026 10:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519419; cv=none; b=cF45kvjkBGCBK1oyrSxHqkfOyZs0gMvNRXIhmrXmGhviXECW+E3BhTG5ubgqXj2msV7FTDumv1pny5inRZVdbts6afPVWYZW0azGH9uS0a3AzR9s5Fkjr8P3PrfBvBw96iXOeyqsby5nUpIvqI/KM/RCi4hYu36HLC73QVv3D5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519419; c=relaxed/simple;
	bh=CRAyTRPorJp2MyL1wvnONUON/dshR3MBUaAS7DxKxO0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aEiFAc9BW+41jqLoR4Bgh+qlNYsZfUo51z2pxNXTF5NmeLp0Z27IfG7iDiHnYYB4glIR3oMYOc7VPNmB1fUz3/fnk1dgYP2dqI2g3mDTsg1iIiqV7otMgj4rfUWHjUSGt+WXsFxlkagVn6LAwHfB3z4Dvz/zJ1uUT55NW99Q9J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKuLiJmB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKuLiJmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A021F01560;
	Fri,  4 Sep 2026 10:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788519415;
	bh=alt32ncZUYAMs1hUtHuw1oAyZ9AhPDNwWLyZ/PqTu3s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LKuLiJmBa1kmwZXDBaQ/RuU4QDwo6uDQPKo3byITybUwASshHnlpB/Nba5PfyZ4qn
	 Zg2PzQ71vB/2NwtqUxBWsH1lzqy3oRuQYw/A5IWjniXdNfhiad2jc0pQuseArTsRNg
	 p/CiR5Zc2a/KaG9teOGc35h+hQPMifZpWDc2utJO9pLa0JS0o1Sb9eIkPohmklSxOt
	 SSbzQ9d2Ko5YmrhGOiJTWDNR+AjB7mjjLDOgs+gSsl5IXL6+irOBkf/S7kG57HdpX5
	 bPEVwCW3pDpEzOXwH81J6SEeG7Ck7cSteC/cK6AycQKHfeTboelmks3wWnQp6LnGgf
	 g1n/yU4847wNA==
From: Christian Brauner <brauner@kernel.org>
To: Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Kaitao Cheng <chengkaitao@kylinos.cn>
In-Reply-To: <20260903050207.7015-1-kaitao.cheng@linux.dev>
References: <20260903050207.7015-1-kaitao.cheng@linux.dev>
Subject: Re: [PATCH] fs/dax: Remove redundant deferred list initialization
Message-Id: <20260904-erbauen-wannen-junggeblieben-3347b4280185@brauner>
Date: Fri, 04 Sep 2026 12:56:50 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=891; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CRAyTRPorJp2MyL1wvnONUON/dshR3MBUaAS7DxKxO0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTNWvz5SE3G1t6tkbr+fKn6fSflDrQ8KORyeeRzU+uua
 SKniJBcRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES86hn+e4bM5/Y9my9rMPXU
 07LS6l+brRbHmzaqv3zIOW8+o77ybIb/CfucnF7yvl4u+zDm/Jwjl3uu3M+ZfOTxpMy/r67sqF1
 ymREA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 03 Sep 2026 13:02:07 +0800, Kaitao Cheng wrote:
> fs/dax: Remove redundant deferred list initialization

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

[1/1] fs/dax: Remove redundant deferred list initialization
      https://git.kernel.org/vfs/vfs/c/4dda2f40edd8

