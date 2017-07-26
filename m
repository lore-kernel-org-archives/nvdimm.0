Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 26 Jul 2017 10:20:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 1/1] f2fs: dax: implement direct access
Message-ID: <20170726172011.GA30142@infradead.org>
References: <1500552639-18523-1-git-send-email-sunqiuyang@huawei.com>
 <CAA9_cmeyVXgu1-ozb7b346ANq+P3e3ATWYfoVGkAKrn5cmo=Hw@mail.gmail.com>
 <20170726072634.GA4684@infradead.org>
 <CAPcyv4igEW-mFDGywh16QLqywuOusu2u6UboppfzzQ_RRvcgVw@mail.gmail.com>
 <20170726170147.GA31930@infradead.org>
 <CAPcyv4iNP0qxL5vToffBivkQWyUquD7HrgNmvYXQW9ejhFrAmA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iNP0qxL5vToffBivkQWyUquD7HrgNmvYXQW9ejhFrAmA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, sunqiuyang <sunqiuyang@huawei.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 10:11:08AM -0700, Dan Williams wrote:
> Until HMAT came along we had no data in the kernel how to pick a sane
> default, but we could now very easily make a "if pmem performance <
> dram, disable dax by default" policy in the kernel.

I'd rather do it the other way around - if HMAT is present and
pmem performance >= dram use dax.  Else require the explicit -o dax
for now to enable it.  If an explicit -o nodax is specified disable
DAX even if HMAT says it is faster.

> The question for this patch is do we want to add yet another
> filesystem that adds "-o dax" or require use of per-inode flags to
> enable dax.

Please stick to the mount option.  After spending a lot of time with
DAX and various memory techologies I'm pretty confident that the inode
flag is the wrong thing to do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
