Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4046A15F30A;
	Wed,  5 Jun 2024 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603240; cv=none; b=hGYS0Vf05djAuZeY8K/im8I0LlowMx9CfxFO7t31XeYTDOGAYosqkFyxYZF288L7NLMuPTFt3L+np2PkLlQMADFFJzx6yD9GNrjW+SXKumI+EUnvxln9AhmubNOq9dGT6RHyC/SAjWdDkmeVAijxPbtGCjVSbbFrRlnLDpYsUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603240; c=relaxed/simple;
	bh=MCeVoSKNIdtoy7CTBwxYCfSx8QwdW+Qb1wNQYlSRnmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PduV3OHKkIBvARwOmAQ29kErlkQvk+pRdA3LZMTaYUz0xTdRV2dryPIyH/9cPwU2trhNeiLtSOYi+3o6ot7TLdgmuzglIXXYYAhI39qzgwiEjF3uPqImlhPVm5kWYPCnXZEd1MQpSUZZCToy6k9XoSGcjRWAWm1H1UJtmiM2MwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljwr7VUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljwr7VUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68301C4AF0A;
	Wed,  5 Jun 2024 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717603239;
	bh=MCeVoSKNIdtoy7CTBwxYCfSx8QwdW+Qb1wNQYlSRnmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ljwr7VULmXeIm0GHuYgub2XWeLiKd+SMBu5J4G/TpshqnpP4+ihHAvUJ/zbdBg/qB
	 9uDEHoY2CD/EGlKWkAWClAhdKeZHYnOcVFTBJ8ElxSXfOusWRyymAJh09w3eAkYFYH
	 NQzsF7D/a0e3kFz9tlMAhtBtLgIHOkSscPp/NHIW8cpNtOiISsxLnOlJfopqh4pz8w
	 htwaS6rzoZ0spVkDbPFMb4htShMn+U68IwqRa5VipC/LzK5YqEtzIUcb3FgFnZJN0z
	 XPNrRUZXsR+aCFbw3yqxH2MnUrjn/NVFhBl92CIcZ6qCpVucrLC+NyAHP18e8hpDKb
	 xvR5rNPDdKQ7A==
Date: Wed, 5 Jun 2024 10:00:35 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 06/12] block: factor out flag_{store,show} helper for
 integrity
Message-ID: <ZmCLo3aBTq4Tgj_N@kbusch-mbp.dhcp.thefacebook.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605063031.3286655-7-hch@lst.de>

On Wed, Jun 05, 2024 at 08:28:35AM +0200, Christoph Hellwig wrote:
> Factor the duplicate code for the generate and verify attributes into
> common helpers.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
