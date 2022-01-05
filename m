Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBB12C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418368; x=1672954368;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nCAaItum+5HppG++YWpzN72ImzToj0lcy7j7tv0h9UU=;
  b=nJD8m2ReFCxA6UdnmX4OAuajiXIchQTwe9M1gVBMpimvfN4UbzOpNtae
   wR/3wHZGW27Ux7BthngDminj7qGqLO2EKMKOccNkndE3MVVJ6JhPZQiPG
   kL68+AEAmEIc/uMLvr+86/1nFYHPo0IruJfZQBYDMaFokOn8Z2TeoFRvM
   /zQ89YZRYI8M4CPJSVxzYh8W+ZwE3qD4QN3gTePNHXpOK4tGPSSHrZLSF
   Rq2zG9qSsk0w6X4NWsO2dARbV4C30nz3oUkEQnpuRQdFNtX/dVpU+F5gm
   YIJq/Or9HM3m25nn4sSvjK8/oTMoZgrkapXRf3mIjdSTjFwFMPqdgDXpY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240084128"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="240084128"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="668240795"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:48 -0800
Subject: [ndctl PATCH v3 13/16] ndctl: Drop executable bit for
 bash-completion script
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:47 -0800
Message-ID: <164141836772.3990253.4996882214531720931.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The rpm build process warns:

*** WARNING: ./usr/share/bash-completion/completions/ndctl is executable but has no shebang, removing executable bit

Clear the unnecessary executable bit since completion helpers are sourced,
not executed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 contrib/ndctl |    0 
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 contrib/ndctl

diff --git a/contrib/ndctl b/contrib/ndctl
old mode 100755
new mode 100644

