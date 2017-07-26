Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170726072634.GA4684@infradead.org>
References: <1500552639-18523-1-git-send-email-sunqiuyang@huawei.com>
 <CAA9_cmeyVXgu1-ozb7b346ANq+P3e3ATWYfoVGkAKrn5cmo=Hw@mail.gmail.com>
 <20170726072634.GA4684@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 09:53:07 -0700
Message-ID: <CAPcyv4igEW-mFDGywh16QLqywuOusu2u6UboppfzzQ_RRvcgVw@mail.gmail.com>
Subject: Re: [PATCH v8 1/1] f2fs: dax: implement direct access
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, sunqiuyang <sunqiuyang@huawei.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 12:26 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jul 25, 2017 at 05:15:10PM -0700, Dan Williams wrote:
>> We're in the process of walking back and potentially deprecating the
>> use of the dax mount option for xfs and ext4 since dax can have
>> negative performance implications if page cache memory happens to be
>> faster than pmem. It should be limited to applications that
>> specifically want the semantic, not globally enabled for the entire
>> mount. xfs has went ahead and added the XFS_DIFLAG2_DAX indoe flag for
>> per-inode enabling of dax.
>>
>> I'm wondering if any new filesystem that adds dax support at this
>> point should do so with inode flags and not a mount option?
>
> That tradeoff is not one that the application should make, but one that
> should depend on the storage medium. To make things worse it might also
> depend on the type of access. E.g. with certain media it makes a lot of
> sense to cache writes in the page cache, but generally not reads.
> I've been spending some time to analyze how that could be done, but
> I've not made real progress on it.
>
> XFS_DIFLAG2_DAX is unfortunately totally unhelpful with that.

It allows for opt-in for applications, or administrators of those
applications, that know the type of access. There's also the new HMAT
(heterogeneous memory attributes table) in ACPI that can indicate the
relative performance of pmem to system-ram if userspace needs data to
make a decision. It would be interesting to have an automatic policy
in the kernel, but we also need a mechanism for explicit
configurations.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
