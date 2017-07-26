Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 26 Jul 2017 13:11:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 1/1] f2fs: dax: implement direct access
Message-ID: <20170726201136.GA30039@infradead.org>
References: <1500552639-18523-1-git-send-email-sunqiuyang@huawei.com>
 <CAA9_cmeyVXgu1-ozb7b346ANq+P3e3ATWYfoVGkAKrn5cmo=Hw@mail.gmail.com>
 <20170726072634.GA4684@infradead.org>
 <CAPcyv4igEW-mFDGywh16QLqywuOusu2u6UboppfzzQ_RRvcgVw@mail.gmail.com>
 <20170726170147.GA31930@infradead.org>
 <CAPcyv4iNP0qxL5vToffBivkQWyUquD7HrgNmvYXQW9ejhFrAmA@mail.gmail.com>
 <20170726172011.GA30142@infradead.org>
 <CAPcyv4hdk8XyYJ5pYvAgUZRoE-SzACNprQm1xaM1KUqBONC8Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hdk8XyYJ5pYvAgUZRoE-SzACNprQm1xaM1KUqBONC8Qw@mail.gmail.com>
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

On Wed, Jul 26, 2017 at 12:16:11PM -0700, Dan Williams wrote:
> Silently turn on DAX if HMAT says its ok?

Yes, absolutely.  I want my system to do the right thing by default,
and if HMAT says bypassing the page cache is a clear advatange it
should be the default.

> I think we would instead
> want a "-o autodax" for that case and then "-o dax" and "-o nodax" for
> the force cases.

Why?

> I think it's easier to administer than the dax mount option. If
> someone wants dax on only in a sub-tree they can set the flag on that
> parent directory and have a policy in dax filesystems that children
> inherit the dax policy from the parent. That seems a better
> administrative model than trying to get it all right globally at mount
> time.

And why exactly? If DAX is faster for file a in directory X it will
be just as fast for a file b in directory Y.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
