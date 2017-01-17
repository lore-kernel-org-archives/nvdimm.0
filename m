From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Date: Mon, 16 Jan 2017 23:57:35 -0800
Message-ID: <20170117075735.GB19654@infradead.org>
References: <20170114002008.GA25379@linux.intel.com>
 <20170114082621.GC10498@birch.djwong.org>
 <x49wpduzseu.fsf@dhcp-25-115.bos.redhat.com>
 <20170117015033.GD10498@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117015033.GD10498-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Jan 16, 2017 at 05:50:33PM -0800, Darrick J. Wong wrote:
> I wouldn't consider it a barrier in general (since ext4 also prints
> EXPERIMENTAL warnings for DAX), merely one for XFS.  I don't even think
> it's that big of a hurdle -- afaict XFS ought to be able to achieve this
> by modifying iomap_begin to allocate new pmem blocks, memcpy the
> contents, and update the memory mappings.  I think.

Yes, and I have a working prototype for that.  I'm just way to busy
with lots of bugfixing at the moment but I plan to get to it in this
merge window.  I also agree that we can't mark a feature as fully
supported until it doesn't conflict with other features.

And I'm not going to get start on the PMEM_IMMUTABLE bullshit, please
don't even go there folks, it's a dead end.
