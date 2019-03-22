Return-Path: <owner-linux-mm@kvack.org>
From: Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 0/5] Page demotion for memory reclaim
Date: Thu, 21 Mar 2019 17:20:54 -0700
Message-ID: <2137A80F-CC90-411B-A1AF-A56384ADE0B8@nvidia.com>
In-Reply-To: <CAHbLzkrLyG-j8kRrrQ==4Y4LDDLubvXMF88muyzXWAQWKw1ZSw@mail.gmail.com>
References: <20190321200157.29678-1-keith.busch@intel.com>
 <5B5EFBC2-2979-4B9F-A43A-1A14F16ACCE1@nvidia.com>
 <20190321223706.GA29817@localhost.localdomain>
 <CAHbLzkrLyG-j8kRrrQ==4Y4LDDLubvXMF88muyzXWAQWKw1ZSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_MailMate_9EF958FC-2C3D-4B16-B110-D853B6A94A0D_=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: owner-linux-mm@kvack.org
To: Yang Shi <shy828301@gmail.com>
Cc: Keith Busch <keith.busch@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, David Nellans <dnellans@nvidia.com>
List-ID: <linux-nvdimm@lists.01.org>

--=_MailMate_9EF958FC-2C3D-4B16-B110-D853B6A94A0D_=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 21 Mar 2019, at 16:02, Yang Shi wrote:

> On Thu, Mar 21, 2019 at 3:36 PM Keith Busch <keith.busch@intel.com> wro=
te:
>>
>> On Thu, Mar 21, 2019 at 02:20:51PM -0700, Zi Yan wrote:
>>> 1. The name of =E2=80=9Cpage demotion=E2=80=9D seems confusing to me,=
 since I thought it was about large pages
>>> demote to small pages as opposite to promoting small pages to THPs. A=
m I the only
>>> one here?
>>
>> If you have a THP, we'll skip the page migration and fall through to
>> split_huge_page_to_list(), then the smaller pages can be considered,
>> migrated and reclaimed individually. Not that we couldn't try to migra=
te
>> a THP directly. It was just simpler implementation for this first atte=
mpt.
>>
>>> 2. For the demotion path, a common case would be from high-performanc=
e memory, like HBM
>>> or Multi-Channel DRAM, to DRAM, then to PMEM, and finally to disks, r=
ight? More general
>>> case for demotion path would be derived from the memory performance d=
escription from HMAT[1],
>>> right? Do you have any algorithm to form such a path from HMAT?
>>
>> Yes, I have a PoC for the kernel setting up a demotion path based on
>> HMAT properties here:
>>
>>   https://git.kernel.org/pub/scm/linux/kernel/git/kbusch/linux.git/com=
mit/?h=3Dmm-migrate&id=3D4d007659e1dd1b0dad49514348be4441fbe7cadb
>>
>> The above is just from an experimental branch.
>>
>>> 3. Do you have a plan for promoting pages from lower-level memory to =
higher-level memory,
>>> like from PMEM to DRAM? Will this one-way demotion make all pages sin=
k to PMEM and disk?
>>
>> Promoting previously demoted pages would require the application do
>> something to make that happen if you turn demotion on with this series=
=2E
>> Kernel auto-promotion is still being investigated, and it's a little
>> trickier than reclaim.
>
> Just FYI. I'm currently working on a patchset which tries to promotes
> page from second tier memory (i.e. PMEM) to DRAM via NUMA balancing.
> But, NUMA balancing can't deal with unmapped page cache, they have to
> be promoted from different path, i.e. mark_page_accessed().

Got it. Another concern is that NUMA balancing marks pages inaccessible
to obtain access information. It might add more overheads on top of page =
migration
overheads. Considering the benefit of migrating pages from PMEM to DRAM
is not as large as =E2=80=9Cbring data from disk to DRAM=E2=80=9D, the ov=
erheads might offset
the benefit, meaning you might see performance degradation.

>
> And, I do agree with Keith, promotion is definitely trickier than
> reclaim since kernel can't recognize "hot" pages accurately. NUMA
> balancing is still corse-grained and inaccurate, but it is simple. If
> we would like to implement more sophisticated algorithm, in-kernel
> implementation might be not a good idea.

I agree. Or hardware vendor, like Intel, could bring more information
on page hotness, like multi-bit access bits or page-modification log
provided by Intel for virtualization.



--
Best Regards,
Yan Zi

--=_MailMate_9EF958FC-2C3D-4B16-B110-D853B6A94A0D_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBAgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAlyUKmYPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKleMP/RceC2q7vQiOE19ilpxcSX4iAX7dUwtbkZg0
YVrSR3WceWx6L62+6B9RYCGPZEnMYGm1UJFKG+wBAO7QsWv11lt1baBqtNn6ORSX
tvgRMOVNW65YfCy/6vciv+nRuLkK/87aOF2nfie+RUIv6yt+KK0sWm1qN0x6vvHH
AXNXNSz0yUpcJqOhktVOCyAdLcI16afxmLdYDReOpMinToKySZVUswpA/BMoX/qP
zUH/96JflS5p8QGs07A8M1kGxG9shQldIEQIkbuOy3JuqAA4dr7q3mB9Kz3RKgwg
iPKMpEFEZWmwSJfYFrr/frlwlua3HP+NHpfvlP3lZQJcFUyB2TAIkIbUtsZcDJ9R
Z2Nb4CEE8MDusB3Fqg3KQE9cGJ++PFAA+QN2Y8UNBngi1Gcpjxxxd5JSdjI27R2c
xRrYZQy6BYW3WgMg+jKq/Gjf2PHRal+KDV+ttuxTFp6pPMJpdt3MdylptI8it8jZ
ro5yeu6yeV+fe9QkvlTrRKcvndSwANvx/H9ZWRdwKiHAnWWxChzq2fRaezOjNLzP
VB+8/5uST6eg5+r/Z7TIkkwOT9mNjrxfgRqW6jRTMOe15JAJlzh1Za9REQgCQtLI
HxvHdp0z0JkFBLwrtWCFkHeJsJ1vs7r6Red1h1ZjDYwHWH1OQ3X7qml6P1DzyFtY
qFY2/Suf
=+UmC
-----END PGP SIGNATURE-----

--=_MailMate_9EF958FC-2C3D-4B16-B110-D853B6A94A0D_=--
