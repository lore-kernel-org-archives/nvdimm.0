Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F90270
	for <nvdimm@lists.linux.dev>; Thu, 20 May 2021 22:43:19 +0000 (UTC)
IronPort-SDR: fznzU/tcU8X1Ba3yLkTobq26ZAIMND6IQ+Hg/FHlvbs00ouOVcCwjBU3Jsm6xzr4BWL9h1x35Q
 0tjzCzjTUZ1A==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="222455737"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="222455737"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 15:43:19 -0700
IronPort-SDR: mMQMSYd1yfKI2Urg85Ue4TbDfYhMGP5jGTkcroBhIy9OQRNQRldysunxHPyq954QC8M0OJPUqF
 Atp9Ezmu8wSQ==
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="475424089"
Received: from rtiwar1x-mobl1.gar.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.33.53])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 15:43:19 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: nvdimm@lists.linux.dev,
	linux-nvdimm@lists.01.org,
	Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [ndctl PATCH] libndctl/papr: Fix probe for papr-scm compatible nvdimms
Date: Thu, 20 May 2021 16:42:50 -0600
Message-Id: <162155047909.1258632.4026902377973863905.b4-ty@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517154824.142237-1-vaibhav@linux.ibm.com>
References: <20210517154824.142237-1-vaibhav@linux.ibm.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 17 May 2021 21:18:24 +0530, Vaibhav Jain wrote:
> With recent changes introduced for unification of PAPR and NFIT
> families the probe for papr-scm nvdimms is broken since they don't
> expose 'handle' or 'phys_id' sysfs attributes. These attributes are
> only exposed by NFIT and 'nvdimm_test' nvdimms. Since 'unable to read'
> these sysfs attributes is a non-recoverable error hence this prevents
> probing of 'PAPR-SCM' nvdimms and ndctl reports following error:
> 
> [...]

Applied, thanks!

[1/1] libndctl/papr: Fix probe for papr-scm compatible nvdimms
      commit: e086106b4d81a2079141c848db7695451c04e877

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>
