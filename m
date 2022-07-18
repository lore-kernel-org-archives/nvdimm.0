Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A6A323C
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658161193; x=1689697193;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=wx+2tefsnxjC6/SPkWBMHDk4yQRZKqq/stF6GFC0Kjs=;
  b=NG76tYAuVvXHUkH2k1ha98326upkeWU6VYMgsfXg0nuiBaeEuEVq1BAb
   nV9wHM/OmepSZjjXHll5Yw+BYtpLOCkjNJPzeZvxY+HdhiaxxL/Cf7wjA
   U0Ba2+OXSRcMJrswRj5aCQJzHgHBIAGYfWiRPa9tXax9R4/56ZyVoohoT
   EpnvohhsBpfaLItYC4Fl2JMvV009A8D9uvLJAn0FJyVZR8heZHw3LMTyq
   pRaKyoVrRvBCViS8leL0TwBQJQaUSfms/TQFxtoFApZPp+8O8Kg56Kzpf
   D+4FTr9oaeI+jLJfGErqM0Luy/6Q4CvfxLyvjY3f54vFYzr3HRe/qjD5o
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="266667138"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="266667138"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 09:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="739527408"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jul 2022 09:19:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 09:19:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 09:19:52 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 18 Jul 2022 09:19:52 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Jane Chu <jane.chu@oracle.com>, "bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: [PATCH v3] x86/mce: retrieve poison range from hardware
Thread-Topic: [PATCH v3] x86/mce: retrieve poison range from hardware
Thread-Index: AQHYmje+5joA3gBAok2TIuU+DOldN62ETyBg
Date: Mon, 18 Jul 2022 16:19:51 +0000
Message-ID: <41db4a4b17a848798e487a058a2bc237@intel.com>
References: <20220717234805.1084386-1-jane.chu@oracle.com>
In-Reply-To: <20220717234805.1084386-1-jane.chu@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

+	m.misc =3D (MCI_MISC_ADDR_PHYS << 6) | __ffs64(mem_err->physical_addr_mas=
k);

Do we want to unconditionally trust the sanity of the BIOS provided physica=
l_address_mask?

There's a warning comment on the kernel __ffs64() function:

 * The result is not defined if no bits are set, so check that @word
 * is non-zero before calling this.

Otherwise, this looks like a good idea.

-Tony
