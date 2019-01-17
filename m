Return-Path: <owner-linux-mm@kvack.org>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH] mm: hwpoison: use do_send_sig_info() instead of
 force_sig() (Re: PMEM error-handling forces SIGKILL causes kernel panic)
From: William Kucharski <william.kucharski@oracle.com>
In-Reply-To: <6fa27824-d86d-f642-db7c-a13faaac527d@oracle.com>
Date: Thu, 17 Jan 2019 02:44:58 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <00575D78-10FE-4A05-9BAB-5A2992AB401D@oracle.com>
References: <e3c4c0e0-1434-4353-b893-2973c04e7ff7@oracle.com>
 <CAPcyv4j67n6H7hD6haXJqysbaauci4usuuj5c+JQ7VQBGngO1Q@mail.gmail.com>
 <20190111081401.GA5080@hori1.linux.bs1.fc.nec.co.jp>
 <20190116093046.GA29835@hori1.linux.bs1.fc.nec.co.jp>
 <97e179e1-8a3a-5acb-78c1-a4b06b33db4c@oracle.com>
 <20190116233207.GA5868@hori1.linux.bs1.fc.nec.co.jp>
 <6fa27824-d86d-f642-db7c-a13faaac527d@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Jane Chu <jane.chu@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



> On Jan 16, 2019, at 6:07 PM, Jane Chu <jane.chu@oracle.com> wrote:
>=20
> It's just coding style I'm used to, no big deal.
> Up to you to decide. :)

Personally I like a (void) cast as it's pretty long-standing syntactic =
sugar to cast a call that returns a value we don't care about to (void) =
to show we know it returns a value and we don't care.

Without it, it may suggest we either didn't know it returned a value or =
that we neglected to check the return value.

However, in current use elsewhere (e.g. in send_sig_all() and =
__oom_kill_process()), no such (void) cast is added, so it seems better =
to match current usage elsewhere in the kernel.

Reviewed-by: William Kucharski <william.kucharski@oracle.com>
