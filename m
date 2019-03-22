Return-Path: <owner-linux-mm@kvack.org>
From: Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 0/5] Page demotion for memory reclaim
Date: Thu, 21 Mar 2019 17:12:33 -0700
Message-ID: <F33CDC43-745B-4555-B8E0-D50D8024C727@nvidia.com>
In-Reply-To: <20190321223706.GA29817@localhost.localdomain>
References: <20190321200157.29678-1-keith.busch@intel.com>
 <5B5EFBC2-2979-4B9F-A43A-1A14F16ACCE1@nvidia.com>
 <20190321223706.GA29817@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_MailMate_2FF9B97D-293E-453D-9986-85B2771222A1_=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: owner-linux-mm@kvack.org
To: Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, David Nellans <dnellans@nvidia.com>
List-ID: <linux-nvdimm@lists.01.org>

--=_MailMate_2FF9B97D-293E-453D-9986-85B2771222A1_=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<snip>
>> 2. For the demotion path, a common case would be from high-performance=
 memory, like HBM
>> or Multi-Channel DRAM, to DRAM, then to PMEM, and finally to disks, ri=
ght? More general
>> case for demotion path would be derived from the memory performance de=
scription from HMAT[1],
>> right? Do you have any algorithm to form such a path from HMAT?
>
> Yes, I have a PoC for the kernel setting up a demotion path based on
> HMAT properties here:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kbusch/linux.git/comm=
it/?h=3Dmm-migrate&id=3D4d007659e1dd1b0dad49514348be4441fbe7cadb
>
> The above is just from an experimental branch.

Got it. Thanks.

>
>> 3. Do you have a plan for promoting pages from lower-level memory to h=
igher-level memory,
>> like from PMEM to DRAM? Will this one-way demotion make all pages sink=
 to PMEM and disk?
>
> Promoting previously demoted pages would require the application do
> something to make that happen if you turn demotion on with this series.=

> Kernel auto-promotion is still being investigated, and it's a little
> trickier than reclaim.
>
> If it sinks to disk, though, the next access behavior is the same as
> before, without this series.

This means, when demotion is on, the path for a page would be DRAM->PMEM-=
>Disk->DRAM->PMEM->=E2=80=A6 .
This could be a start point.

I actually did something similar here for two-level heterogeneous memory =
structure: https://github.com/ysarch-lab/nimble_page_management_asplos_20=
19/blob/nimble_page_management_4_14_78/mm/memory_manage.c#L401.
What I did basically was calling shrink_page_list() periodically, so page=
s will be separated
in active and inactive lists. Then, pages in the _inactive_ list of fast =
memory (like DRAM)
are migrated to slow memory (like PMEM) and pages in the _active_ list of=
 slow memory are migrated
to fast memory. It is kinda of abusing the existing page lists. :)

My conclusion from that experiments is that you need high-throughput page=
 migration mechanisms,
like multi-threaded page migration, migrating a bunch of pages in a batch=
 (https://github.com/ysarch-lab/nimble_page_management_asplos_2019/blob/n=
imble_page_management_4_14_78/mm/copy_page.c), and
a new mechanism called exchange pages (https://github.com/ysarch-lab/nimb=
le_page_management_asplos_2019/blob/nimble_page_management_4_14_78/mm/exc=
hange.c), so that using page migration to manage multi-level
memory systems becomes useful. Otherwise, the overheads (TLB shootdown an=
d other kernel activities
in the page migration process) of page migration may kill the benefit. Be=
cause the performance
gap between DRAM and PMEM is supposed to be smaller than the one between =
DRAM and disk,
the benefit of putting data in DRAM might not compensate the cost of migr=
ating cold pages from DRAM
to PMEM. Namely, directly putting data in PMEM after DRAM is full might b=
e better.


>> 4. In your patch 3, you created a new method migrate_demote_mapping() =
to migrate pages to
>> other memory node, is there any problem of reusing existing migrate_pa=
ges() interface?
>
> Yes, we may not want to migrate everything in the shrink_page_list()
> pages. We might want to keep a page, so we have to do those checks firs=
t. At
> the point we know we want to attempt migration, the page is already
> locked and not in a list, so it is just easier to directly invoke the
> new __unmap_and_move_locked() that migrate_pages() eventually also call=
s.

Right, I understand that you want to only migrate small pages to begin wi=
th. My question is
why not using the existing migrate_pages() in your patch 3. Like:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a5ad0b35ab8e..0a0753af357f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1261,6 +1261,20 @@ static unsigned long shrink_page_list(struct list_=
head *page_list,
                        ; /* try to reclaim the page below */
                }

+               if (!PageCompound(page)) {
+                       int next_nid =3D next_migration_node(page);
+                       int err;
+
+                       if (next_nid !=3D TERMINAL_NODE) {
+                               LIST_HEAD(migrate_list);
+                               list_add(&migrate_list, &page->lru);
+                               err =3D migrate_pages(&migrate_list, allo=
c_new_node_page, NULL,
+                                       next_nid, MIGRATE_ASYNC, MR_DEMOT=
ION);
+                               if (err)
+                                       putback_movable_pages(&migrate_li=
st);
+                       }
+               }
+
                /*
                 * Anonymous process memory has backing store?
                 * Try to allocate it some swap space here.

Because your new migrate_demote_mapping() basically does the same thing a=
s the code above.
If you are not OK with the gfp flags in alloc_new_node_page(), you can ju=
st write your own
alloc_new_node_page(). :)

>
>> 5. In addition, you only migrate base pages, is there any performance =
concern on migrating THPs?
>> Is it too costly to migrate THPs?
>
> It was just easier to consider single pages first, so we let a THP spli=
t
> if possible. I'm not sure of the cost in migrating THPs directly.

AFAICT, when migrating the same amount of 2MB data, migrating a THP is mu=
ch quick than migrating
512 4KB pages. Because you save 511 TLB shootdowns in THP migration and c=
opying 2MB contiguous data
achieves higher throughput than copying individual 4KB pages. But it high=
ly depends on whether
any subpage in a THP is hotter than others, so migrating a THP as a whole=
 might hurt performance
sometimes. Just some of my observation in my own experiments.


--
Best Regards,
Yan Zi

--=_MailMate_2FF9B97D-293E-453D-9986-85B2771222A1_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBAgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAlyUKHEPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKG6oP/3OQ573fMxvauLNuxYpady5bM1FB6ugGHtCW
XEzJKifXTMVue0qe8Jctz+tHwzljpzuralc3brVasDu3CLBAOKbzHtWuOrEuqprm
njE8WJEY/tcegYGuiYzIi+EIr7r0+hINCZiqbdQqxyXRKRahYNnoqVBG/riBusYT
cFwjE6Rg6hadb3QimDz4zYfHIk9ztTc4HbNwLOOrm8VhzLTXOWyq2b+xfe8Ko2Oq
BRtJcX49jIP3HMAo07YzSultExpHuYJnNTvNvAlkJVAMWAKM4HxRsNzBopRABgKg
3bA78ay4WODc0rKiqfoGOq+L3zpB+Qwwdq/G6OOuRl+/Hlp2hXAh3zEUQu9q5m2B
35cskVwYw1YG2zVJauI2MWRXbklFp8aMNJYn0jpF3U3xcTs+qVw5+Bo81sq1vFT6
oOkqsiXKPxp8lIPYFpRJA45UHw1oAOEPNyD7gAsz7b+TKQ6x1/JaDpXh0sCzMyWl
jyxexCon0SSLnOw5iRX6yyGVQsJkrp/5GqHtFwrTn+liXHl/p0Kisk1Em+y70dj5
BTHIQ7BLSavWJ+s4BczEu6ur4mJUIcQhtSFFodKAqv6CN5NioBd8k2ZoXsLJ5NBi
ufQd5XsFSNp8Zkv7GZk077NKRFhB5FsaHN4HzWsXwi0C0GbsidkPP61FGw/G2gQS
MkLYyxFh
=lbIR
-----END PGP SIGNATURE-----

--=_MailMate_2FF9B97D-293E-453D-9986-85B2771222A1_=--
