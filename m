Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 12 Jun 2019 05:07:49 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 2/2] Implement sharing/unsharing of PMDs for FS/DAX
Message-ID: <20190612020749.sjpuquzxrprkalfy@box>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-3-git-send-email-larry.bassel@oracle.com>
 <20190514130147.2pk2xx32aiomm57b@box>
 <20190524160711.GF19025@ubuette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524160711.GF19025@ubuette>
Sender: owner-linux-mm@kvack.org
To: Larry Bassel <larry.bassel@oracle.com>
Cc: mike.kravetz@oracle.com, willy@infradead.org, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 24, 2019 at 09:07:11AM -0700, Larry Bassel wrote:
> Again, I don't think this can happen in DAX. The only sharing allowed
> is for FS/DAX/2MiB pagesize.

Hm. I still don't follow. How do you guarantee that DAX actually allocated
continues space for the file on backing storage and you can map it with
PMD page? I believe you don't have such guarantee.


-- 
 Kirill A. Shutemov
