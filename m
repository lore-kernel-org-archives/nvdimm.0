Return-Path: <owner-linux-mm@kvack.org>
From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH v2 UPDATE 3/3] ACPI/APEI/EINJ: Allow memory error
 injection to NVDIMM
Date: Mon, 26 Oct 2015 16:26:59 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32B5F5AF@ORSMSX114.amr.corp.intel.com>
References: <1445871783-18365-1-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1445871783-18365-1-git-send-email-toshi.kani@hpe.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>, "bp@alien8.de" <bp@alien8.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

-	pfn =3D PFN_DOWN(param1 & param2);
-	if (!page_is_ram(pfn) || ((param2 & PAGE_MASK) !=3D PAGE_MASK))
+	base_addr =3D param1 & param2;
+	size =3D (~param2) + 1;

We expect the user will supply us with param2 in the form 0xffffffff[fec8]0=
0000
with various numbers of leading 'f' and trailing '0' ... but I don't think =
we actually
check that anywhere.  But we have a bunch of places that assume it is OK, i=
ncluding
this new one.

It's time to fix that.  Maybe even provide a default 0xfffffffffffff000 so =
I can save myself
some typing?

-Tony

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
