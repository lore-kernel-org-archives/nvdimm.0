Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170726170147.GA31930@infradead.org>
References: <1500552639-18523-1-git-send-email-sunqiuyang@huawei.com>
 <CAA9_cmeyVXgu1-ozb7b346ANq+P3e3ATWYfoVGkAKrn5cmo=Hw@mail.gmail.com>
 <20170726072634.GA4684@infradead.org>
 <CAPcyv4igEW-mFDGywh16QLqywuOusu2u6UboppfzzQ_RRvcgVw@mail.gmail.com>
 <20170726170147.GA31930@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 10:11:08 -0700
Message-ID: <CAPcyv4iNP0qxL5vToffBivkQWyUquD7HrgNmvYXQW9ejhFrAmA@mail.gmail.com>
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

On Wed, Jul 26, 2017 at 10:01 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jul 26, 2017 at 09:53:07AM -0700, Dan Williams wrote:
>> It allows for opt-in for applications, or administrators of those
>> applications, that know the type of access.
>
> That's BS.  We need to provide the best possible way to access the
> media to an application.  And whether that's DAX or the page cache
> is an implementation detail that should not matter to the application.
>
> Which doesn't mean there shouldn't be ways to override the default
> that the kernel chose based on hardware details, but it's certainly
> not something for the application to hardcode, but something for
> the adminstrator to decide.

Until HMAT came along we had no data in the kernel how to pick a sane
default, but we could now very easily make a "if pmem performance <
dram, disable dax by default" policy in the kernel.

The question for this patch is do we want to add yet another
filesystem that adds "-o dax" or require use of per-inode flags to
enable dax.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
