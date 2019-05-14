Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 14 May 2019 15:28:20 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 0/2] Share PMDs for FS/DAX on x86
Message-ID: <20190514122820.26zddpb27uxgrwzp@box>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Larry Bassel <larry.bassel@oracle.com>
Cc: mike.kravetz@oracle.com, willy@infradead.org, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 09, 2019 at 09:05:31AM -0700, Larry Bassel wrote:
> This patchset implements sharing of page table entries pointing
> to 2MiB pages (PMDs) for FS/DAX on x86.

-EPARSE.

How do you share entries? Entries do not take any space, page tables that
cointain these entries do.

Have you checked if the patch makes memory consumption any better. I have
doubts in it.
