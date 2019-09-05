From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4] libnvdimm: Enable unit test infrastructure compile
 checks
Date: Thu, 5 Sep 2019 11:50:11 -0300
Message-ID: <20190905145011.GA11796@ziepe.ca>
References: <156763690875.2556198.15786177395425033830.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156763690875.2556198.15786177395425033830.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 04, 2019 at 03:43:31PM -0700, Dan Williams wrote:
> The infrastructure to mock core libnvdimm routines for unit testing
> purposes is prone to bitrot relative to refactoring of that core.
> Arrange for the unit test core to be built when CONFIG_COMPILE_TEST=y.
> This does not result in a functional unit test environment, it is only a
> helper for 0day to catch unit test build regressions.
> 
> Note that there are a few x86isms in the implementation, so this does
> not bother compile testing this architectures other than 64-bit x86.
> 
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/r/156097224232.1086847.9463861924683372741.stgit@dwillia2-desk3.amr.corp.intel.com
> Changes since v3:
> 
> - Switch the Makefile operator from := to += to make sure the unit test
>   infrastructure is incrementally included.
> 
> Jason, lets try this again. This seems to resolve the build error for
> me. I believe ":=" would have intermittent results in a parallel build
> and sometimes result in other targets in drivers/nvdimm/Makefile being
> bypassed. This has been exposed to the 0day robot for a day with no
> reports.

Okay, again we go

Jason
