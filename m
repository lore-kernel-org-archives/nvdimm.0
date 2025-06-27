Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43FA221DB9;
	Fri, 27 Jun 2025 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751056132; cv=none; b=Axh+KJ/3kjrP0J71AKUdbVYAi/o6kcmUvNjYsZjNTc4G4OITHSmQcfwVQVRHGmydvK6GCy64CKwPh0pKfvwagpz7AssuSuM7gDUb4rBKikAj1qDvx8GnM/TQKDbg0dehxCTj+ttI8gac0OmzqStuCWrwe+Sf4o7FtxhDbo7pvdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751056132; c=relaxed/simple;
	bh=f33g7AQTIoumIR81yP3oqisT+p6xQ/smz6jb75JSd7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edN1CB8A1jMu6BpmH2GzVKMbowLh3y02fQ1F4qtenM+zGssSbMCC/CnPPrlmufN/Pto7QoOi68CeLv/sU4/h8Tqt36hBGB6nJkDmEGXKfUJfDSYddGdC18QfAej5cJpNQKxDKIoDJLLmtPWlI6BUd5C0dtMtaQjPww4rERra8V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjwcY67p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjwcY67p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD97C4CEE3;
	Fri, 27 Jun 2025 20:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751056132;
	bh=f33g7AQTIoumIR81yP3oqisT+p6xQ/smz6jb75JSd7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjwcY67phiXKdjFIgm+NBjQUL5EzYzn69zzAq8DaOFO6xB1xWGqOguqzzLJXWbxOF
	 6oGMVHGZjLNqjTRwl8Q1hM0FcEJzM4ehPSR0JHFUbRPDl+6UduRZIcr5vHb3VQTCGO
	 khZj6jaWnrTc5avIeF/HL2oRniIVoFIaf3EZnlwxWIChJx9ZWSFlNmqwuxQKvj1B1n
	 xxDemS/rVxjpC1BoaY9y9v3rYyfaAYwTM9jc6RnZyu2qero0qSKiJl3wDi1M/pIjgP
	 g14p76cvEU9CtAQkoQ89R5nApyPAIkXgkRvyNqqwVmliAwYqY9pWwAhXotV2uAee7Q
	 b1nmHLg5JBGOQ==
From: Kees Cook <kees@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5][for-next/hardening] acpi: nfit: intel: avoid multiple -Wflex-array-member-not-at-end warnings
Date: Fri, 27 Jun 2025 13:28:15 -0700
Message-Id: <175105609270.2134124.11937541280593665883.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aF7pF4kej8VQapyR@kspp>
References: <aF7pF4kej8VQapyR@kspp>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 27 Jun 2025 12:55:19 -0600, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Use the new TRAILING_OVERLAP() helper to fix a dozen instances of
> the following type of warning:
> 
> drivers/acpi/nfit/intel.c:692:35: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> [...]

Thanks for the revs and reviews! :) Since this depends on
TRAILING_OVERLAP, I've snagged it for the hardening tree.

Applied to for-next/hardening, thanks!

[1/1] acpi: nfit: intel: avoid multiple -Wflex-array-member-not-at-end warnings
      https://git.kernel.org/kees/c/5e54510a9389

Take care,

-- 
Kees Cook

