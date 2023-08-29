Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B8A23D2
	for <nvdimm@lists.linux.dev>; Tue, 29 Aug 2023 08:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D93C433C9;
	Tue, 29 Aug 2023 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693296721;
	bh=RKsitqruLeakZo1D6/gvmm5Cw17kgJDQ6/wtIhtx3Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7GaHq0+LRKigL5Kn8yCcnQq3fr1wVnM+Jarqi0qWe98pvwdAxhGSivWnnq+xZKEI
	 UoYioIzBdYJ+9J8sggSh8yBFyTVXf5MQ51CO7QgeAQ+/RxnI+UrsaVtSYRGfXf8JKR
	 68DRbZKiVzOt4dB1gFsrvLhI30EdrbT5P2zAVlpOrU/+1w+X2PUf7YB4YsTJmW7EwJ
	 7TvXnet70vdkNT+hB1gB+WHulUHBhsOh7Qx/MKpmwtp2oeaQ1eFil8VCk34nFM+Sp1
	 gXyVQJcB1bB+5LCK/yXhcPcjAvh59Scq1Q1dhm9wHnCXlQ/FdWCSkxADQSAPQPB6vB
	 GkmKqCowkBxLw==
From: Christian Brauner <brauner@kernel.org>
To: Xueshi Hu <xueshi.hu@smartx.com>
Cc: Christian Brauner <brauner@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	hch@infradead.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	jayalk@intworks.biz,
	daniel@ffwll.ch,
	deller@gmx.de,
	bcrl@kvack.org,
	viro@zeniv.linux.org.uk,
	jack@suse.com,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	miklos@szeredi.hu,
	mike.kravetz@oracle.com,
	muchun.song@linux.dev,
	djwong@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	hughd@google.com
Subject: Re: [PATCH v3] fs: clean up usage of noop_dirty_folio
Date: Tue, 29 Aug 2023 10:11:50 +0200
Message-Id: <20230829-kappen-meinen-0c51bfa4472a@brauner>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230829040029.473810-1-xueshi.hu@smartx.com>
References: <20230829040029.473810-1-xueshi.hu@smartx.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1181; i=brauner@kernel.org; h=from:subject:message-id; bh=RKsitqruLeakZo1D6/gvmm5Cw17kgJDQ6/wtIhtx3Xc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaS8XeE0X7zC/+a5ToXwkP6tq+ffe+sq23qzeTUrp2C3uJho fe+ajlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImU9DAyNBh8vvFMVubWufawk0/v5z ds+Kuc8/L2Q+tlArpzys41XWRkuDDXYfo74/2PbWIrF2j+aXK07m/J2JfZXJkcbrtn7zE7ZgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 29 Aug 2023 12:00:29 +0800, Xueshi Hu wrote:
> In folio_mark_dirty(), it can automatically fallback to
> noop_dirty_folio() if a_ops->dirty_folio is not registered.
> 
> In anon_aops, dev_dax_aops and fb_deferred_io_aops, replacing .dirty_folio
> with NULL makes them identical to default (empty_aops) and since we never
> compare ->a_ops pointer with either of those, we can remove them
> completely.
> 
> [...]

Applied to the vfs.misc branch of the vfs/vfs.git tree.
Patches in the vfs.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.misc

[1/1] fs: clean up usage of noop_dirty_folio
      https://git.kernel.org/vfs/vfs/c/ffb2bc01caae
