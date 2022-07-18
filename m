Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503053C0A
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658172146; x=1689708146;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=eo3D0aeBeJw2UIM3nA8YbDz/YEqpnZylI1xwFHzdsbc=;
  b=N8mkV01X5dKmrHF1Gp72HLz6L73+MR7xuZybZQRIMYjHkbylW/MlL13s
   OkQUatI/4aeeFokFZuuGZWHieTRV5oFgl6dD51lJyqIF9rcO+lOmfxBeh
   AVqlPwL3zTWvCq2AurC8t4n3BtMwVWtlv8PuByvtHFqE+JZldG+aRAvhR
   2hD9Skk+qU86sJ7LWVJ8TzD9eEm87N6VLXdxCwk6mGqB+XR7cH1quWF/R
   SsDJ9vTeK2UP3R9+j5cnDeeqgetAN/BtyRXFrU+ofkwUW8kDtZdLS5Dej
   8S3wXg+3MMcokoeDrDPiKJwFK7Ctdc5QAEI5uHSaOzK1QB0cXDLmTUrFv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287451915"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287451915"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 12:22:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="572540502"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 18 Jul 2022 12:22:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 12:22:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 12:22:24 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 18 Jul 2022 12:22:24 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "chu, jane"
	<jane.chu@oracle.com>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de"
	<hch@lst.de>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: [PATCH v3] x86/mce: retrieve poison range from hardware
Thread-Topic: [PATCH v3] x86/mce: retrieve poison range from hardware
Thread-Index: AQHYmje+5joA3gBAok2TIuU+DOldN62ETyBggACnK4D//4xNwA==
Date: Mon, 18 Jul 2022 19:22:24 +0000
Message-ID: <797a2b64ed0949b6905b3c3e8f049a23@intel.com>
References: <20220717234805.1084386-1-jane.chu@oracle.com>
 <41db4a4b17a848798e487a058a2bc237@intel.com>
 <62d5b13b2cf1a_9291929433@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62d5b13b2cf1a_9291929433@dwillia2-xfh.jf.intel.com.notmuch>
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

> It appears the kernel is trusting that ->physical_addr_mask is non-zero
> in other paths. So this is at least equally broken in the presence of a
> broken BIOS. The impact is potentially larger though with this change,
> so it might be a good follow-on patch to make sure that
> ->physical_addr_mask gets fixed up to a minimum mask value.

Agreed. Separate patch to sanitize early, so other kernel code can just use=
 it.

-Tony
