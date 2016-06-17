From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] xfs: initial/partial support for badblocks
Date: Fri, 17 Jun 2016 15:27:51 -0700
Message-ID: <CAPcyv4gEgcMxCkhPRbj3qvAqA6q1+Tuu0jVuuJSCysbuPmY=9w@mail.gmail.com>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
 <1466125419-17736-3-git-send-email-vishal.l.verma@intel.com>
 <20160617022606.GC11810@birch.djwong.org>
 <20160617192647.GC5893@omniknight.lm.intel.com>
 <20160617195345.GA5046@birch.djwong.org>
 <20160617203237.GD5893@omniknight.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160617203237.GD5893-PxNA6LsHknajYZd8rzuJLNh3ngVCH38I@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 17, 2016 at 1:32 PM, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> What happens if pmem signals a bad block and we try to read anyway?  I know
>> about the read-error-MCE thing, but what's the "more expensive" alternative?
>> CPU exception?
>
> MCE is the CPU exception, and is what we want to avoid at all costs, as
> it can cause the machine to crash.

The MCE being fatal vs recoverable is the difference between platforms
that must avoid badblocks vs those that can consume them and keep
going.
