Return-Path: <owner-linux-mm@kvack.org>
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH] mm/nvdimm: Use correct #defines instead of opencoding
Date: Tue, 21 May 2019 14:49:47 +0000
Message-ID: <AT5PR8401MB1169DEEAA95D4E4EA9C61285AB070@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190514025604.9997-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4iNgFbSq0Hqb+CStRhGWMHfXx7tL3vrDaQ95DcBBY8QCQ@mail.gmail.com>
 <f99c4f11-a43d-c2d3-ab4f-b7072d090351@linux.ibm.com>
 <CAPcyv4gOr8SFbdtBbWhMOU-wdYuMCQ4Jn2SznGRsv6Vku97Xnw@mail.gmail.com>
 <02d1d14d-650b-da38-0828-1af330f594d5@linux.ibm.com>
 <CAPcyv4jcSgg0wxY9FAM4ke9JzVc9Pu3qe6dviS3seNgHfG2oNw@mail.gmail.com>
 <87mujgcf0h.fsf@linux.ibm.com>
In-Reply-To: <87mujgcf0h.fsf@linux.ibm.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> Aneesh Kumar K.V
> Sent: Tuesday, May 21, 2019 4:51 AM
> Subject: Re: [PATCH] mm/nvdimm: Use correct #defines instead of
> opencoding
>=20
...
> @@ -36,6 +36,9 @@ struct nd_pfn_sb {
>  	__le32 end_trunc;
>  	/* minor-version-2 record the base alignment of the mapping */
>  	__le32 align;
> +	/* minor-version-3 record the page size and struct page size
> */
> +	__le32 page_size;
> +	__le32 page_struct_size;
>  	u8 padding[4000];
>  	__le64 checksum;
>  };

You might need to reduce the padding size to offset the extra added
fields.
